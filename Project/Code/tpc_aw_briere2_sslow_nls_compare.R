# ============================================
# Compare two models by water activity (aw): Brière-2 vs. Sharpe–Schoolfield (low-temp)
# - Read aw_temperature_mean_growth.csv
# - Fit both models per aw (nlsLM + bounds, robust)
# - Plot only within observed temperature range; save 6 single plots + a 2×3 grid
# - Export one table: model comparison (R2, RMSE, AIC, ΔAIC, AIC weight)
# ============================================

# Dependencies
need <- c("dplyr","ggplot2","minpack.lm","patchwork")
to_install <- setdiff(need, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, quiet = TRUE)
suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(minpack.lm); library(patchwork)
})

# ---- Load aggregated data (aw × temperature) ----
csv <- "aw_temperature_mean_growth.csv"
stopifnot(file.exists(csv))
aw_mean <- read.csv(csv, stringsAsFactors = FALSE)
stopifnot(all(c("aw","temperature","mean_growth_rate") %in% names(aw_mean)))
aw_levels <- sort(unique(aw_mean$aw))

# ---- Model functions ----
# Brière-2 (T in °C)
briere_fun <- function(T, a, T0, Tmax){
  a * T * (T - T0) * sqrt(pmax(0, Tmax - T))
}
# Sharpe–Schoolfield low-temp (T in K)
k_B  <- 8.617e-5; Tref <- 293.15
ss_low_fun <- function(Tk, B0, E, El, Tl){
  num <- B0 * exp(-E / k_B * (1/Tk - 1/Tref))
  den <- 1 + exp(El / k_B * (1/Tk - 1/Tl))
  num / den
}

# ---- Fitters (nlsLM + bounds + multi-start) ----
fit_briere_one_lm <- function(df){
  df <- df[order(df$temperature), ]
  T <- df$temperature; y <- df$mean_growth_rate
  starts <- expand.grid(
    a    = 10^seq(-8, -4, length.out = 5),
    T0   = seq(min(T)-12, min(T)-2, length.out = 4),
    Tmax = seq(max(T)+2,  max(T)+12, length.out = 4)
  )
  lower <- c(a=0,           T0=min(T)-40, Tmax=max(T)+0.5)
  upper <- c(a=1e-2,        T0=min(T)-0.5, Tmax=max(T)+40)

  best <- NULL
  for (i in seq_len(nrow(starts))){
    st <- as.list(starts[i,])
    st$a    <- max(lower["a"],  min(st$a,  upper["a"]))
    st$T0   <- max(lower["T0"], min(st$T0, upper["T0"]))
    st$Tmax <- max(lower["Tmax"], min(st$Tmax, upper["Tmax"]))
    if (st$T0 >= st$Tmax) next
    try({
      m <- nlsLM(y ~ briere_fun(T, a, T0, Tmax),
                 start = st, lower = lower, upper = upper,
                 control = nls.lm.control(maxiter = 600))
      rss <- sum(resid(m)^2)
      if (is.null(best) || rss < best$rss) best <- list(mod=m, rss=rss)
    }, silent = TRUE)
  }
  if (is.null(best)) return(NULL)
  best$mod
}

fit_ss_low_one_lm <- function(df){
  df <- df[order(df$temperature), ]
  Tk <- df$temperature + 273.15
  y  <- df$mean_growth_rate
  ybar <- mean(y, na.rm = TRUE); ymax <- max(y, na.rm = TRUE)

  starts <- expand.grid(
    B0 = c(ybar, ymax, max(1e-6, 0.5*ybar)),
    E  = c(0.4, 0.6, 0.8),     # eV
    El = c(0.6, 1.0, 2.0),     # eV
    Tl = seq(min(Tk)-15, min(Tk)-5, length.out = 3)  # K
  )
  lower <- c(B0=0,         E=0.2, El=0.2, Tl=min(Tk)-40)
  upper <- c(B0=10*ymax,   E=1.2, El=5.0, Tl=min(Tk)-1)

  best <- NULL
  for (i in seq_len(nrow(starts))){
    st <- as.list(starts[i,])
    st$B0 <- max(lower["B0"], min(st$B0, upper["B0"]))
    st$E  <- max(lower["E"],  min(st$E,  upper["E"]))
    st$El <- max(lower["El"], min(st$El, upper["El"]))
    st$Tl <- max(lower["Tl"], min(st$Tl, upper["Tl"]))
    try({
      m <- nlsLM(y ~ ss_low_fun(Tk, B0, E, El, Tl),
                 start = st, lower = lower, upper = upper,
                 control = nls.lm.control(maxiter = 600))
      rss <- sum(resid(m)^2)
      if (is.null(best) || rss < best$rss) best <- list(mod=m, rss=rss)
    }, silent = TRUE)
  }
  if (is.null(best)) return(NULL)
  best$mod
}

# ---- Batch fitting (both models per aw) ----
fits_briere <- setNames(vector("list", length(aw_levels)), as.character(aw_levels))
fits_sslow  <- setNames(vector("list", length(aw_levels)), as.character(aw_levels))

cat("Fitting models (nlsLM + bounds)...\n")
for (aw_i in aw_levels){
  df_i <- aw_mean %>% filter(aw == aw_i)
  fits_briere[[as.character(aw_i)]] <- fit_briere_one_lm(df_i)
  fits_sslow [[as.character(aw_i)]] <- fit_ss_low_one_lm(df_i)
  cat("  aw=", aw_i,
      " | Brière-2:", ifelse(is.null(fits_briere[[as.character(aw_i)]]),"FAIL","OK"),
      " | SS low:",   ifelse(is.null(fits_sslow [[as.character(aw_i)]]),"FAIL","OK"), "\n", sep="")
}

# ---- Predictions (only within observed T range) ----
pred_all <- bind_rows(lapply(aw_levels, function(aw_i){
  df_i  <- aw_mean %>% filter(aw == aw_i)
  Tmin  <- min(df_i$temperature); Tmax <- max(df_i$temperature)
  Tseq  <- seq(Tmin - 0.5, Tmax + 0.5, by = 0.1)

  bri <- fits_briere[[as.character(aw_i)]]
  ssl <- fits_sslow [[as.character(aw_i)]]

  pred_bri <- if (is.null(bri)) rep(NA_real_, length(Tseq)) else {
    co <- coef(bri); briere_fun(Tseq, co[["a"]], co[["T0"]], co[["Tmax"]])
  }
  pred_ssl <- if (is.null(ssl)) rep(NA_real_, length(Tseq)) else {
    co <- coef(ssl); ss_low_fun(Tseq + 273.15, co[["B0"]], co[["E"]], co[["El"]], co[["Tl"]])
  }

  bind_rows(
    data.frame(aw=aw_i, temperature=Tseq, pred=pred_bri, model="Brière-2"),
    data.frame(aw=aw_i, temperature=Tseq, pred=pred_ssl, model="SS low-temp")
  )
}))

# ---- Plotting: 6 single plots + 2×3 grid (PNG) ----
pal <- c("Brière-2"="#2E86DE", "SS low-temp"="#E17055")
pretty_theme <- function(base_size = 13){
  theme_minimal(base_size = base_size) +
    theme(
      plot.title      = element_text(face = "bold", hjust = 0.5, margin = margin(b=6)),
      axis.title.x    = element_text(margin = margin(t=8)),
      axis.title.y    = element_text(margin = margin(r=8)),
      panel.grid.minor= element_blank(),
      panel.grid.major= element_line(linewidth = 0.25, colour = "grey85"),
      legend.position = "bottom",
      legend.title    = element_blank(),
      plot.margin     = margin(8, 12, 8, 12)
    )
}
outdir <- "tpc_aw_models"
if (!dir.exists(outdir)) dir.create(outdir)

plots <- list()
for (aw_i in aw_levels){
  df_pts  <- aw_mean  %>% filter(aw == aw_i)
  df_line <- pred_all %>% filter(aw == aw_i, !is.na(pred))

  Tmin <- min(df_pts$temperature); Tmax <- max(df_pts$temperature)
  df_line <- df_line %>% filter(temperature >= (Tmin - 0.5), temperature <= (Tmax + 0.5))

  p <- ggplot() +
    geom_point(data = df_pts,
               aes(temperature, mean_growth_rate),
               shape=21, size=3.0, stroke=0.8,
               colour="grey20", fill="white", alpha=0.95) +
    geom_line(data = df_line,
              aes(temperature, pred, colour = model),
              linewidth=1.25, lineend="round") +
    scale_color_manual(values = pal) +
    coord_cartesian(xlim = c(Tmin - 0.5, Tmax + 0.5)) +
    labs(title = paste0("aw = ", aw_i),
         x = "Temperature (°C)", y = "Mean growth rate (mm/day)") +
    pretty_theme(13)

  fn <- file.path(outdir, paste0("TPC_aw_", gsub("[^0-9\\.]+","_", aw_i), "_Briere_vs_SS.png"))
  ggsave(fn, p, width = 6.2, height = 4.6, dpi = 320)
  plots[[as.character(aw_i)]] <- p
}

combined <- wrap_plots(plots, ncol = 3) +
  plot_layout(guides = "collect") & theme(legend.position = "bottom")
ggsave(file.path(outdir, "TPC_aw_grid_2x3.png"), combined, width = 14, height = 9, dpi = 320)

# ---- Metrics and model comparison (no parameter table) ----
calc_metrics <- function(y, yhat, k){
  rss <- sum((y - yhat)^2); tss <- sum((y - mean(y))^2)
  n <- length(y); R2 <- 1 - rss/tss; AIC <- n*log(rss/n) + 2*k
  RMSE <- sqrt(mean((y - yhat)^2))
  list(R2=R2, AIC=AIC, RMSE=RMSE, n=n)
}

# Build per-aw metrics for both models
metrics_rows <- bind_rows(lapply(aw_levels, function(aw_i){
  df_i <- aw_mean %>% filter(aw == aw_i)
  Tobs <- df_i$temperature; yobs <- df_i$mean_growth_rate

  # Brière-2
  m1 <- fits_briere[[as.character(aw_i)]]
  if (!is.null(m1)){
    co <- coef(m1)
    yhat1 <- briere_fun(Tobs, co[["a"]], co[["T0"]], co[["Tmax"]])
    st1 <- calc_metrics(yobs, yhat1, k = 3)  # a, T0, Tmax
    row1 <- data.frame(aw=aw_i, model="Brière-2",
                       R2=st1$R2, RMSE=st1$RMSE, AIC=st1$AIC, n=st1$n)
  } else {
    row1 <- data.frame(aw=aw_i, model="Brière-2",
                       R2=NA, RMSE=NA, AIC=NA, n=length(yobs))
  }

  # SS low-temp
  m2 <- fits_sslow[[as.character(aw_i)]]
  if (!is.null(m2)){
    co <- coef(m2)
    yhat2 <- ss_low_fun(Tobs + 273.15, co[["B0"]], co[["E"]], co[["El"]], co[["Tl"]])
    st2 <- calc_metrics(yobs, yhat2, k = 4)  # B0, E, El, Tl
    row2 <- data.frame(aw=aw_i, model="SS low-temp",
                       R2=st2$R2, RMSE=st2$RMSE, AIC=st2$AIC, n=st2$n)
  } else {
    row2 <- data.frame(aw=aw_i, model="SS low-temp",
                       R2=NA, RMSE=NA, AIC=NA, n=length(yobs))
  }

  bind_rows(row1, row2)
}))

# Table 1: model comparison + ΔAIC + AIC weights
tab1 <- metrics_rows %>%
  group_by(aw) %>%
  mutate(deltaAIC = AIC - min(AIC, na.rm = TRUE),
         aic_w    = exp(-0.5*deltaAIC) / sum(exp(-0.5*deltaAIC), na.rm = TRUE),
         winner   = ifelse(deltaAIC == 0, "best", "")) %>%
  arrange(aw, AIC) %>%
  ungroup() %>%
  select(aw, model, R2, RMSE, AIC, deltaAIC, aic_w, winner)

# Export
if (!dir.exists(outdir)) dir.create(outdir, showWarnings = FALSE)
write.csv(tab1, file.path(outdir, "Table1_aw_model_comparison.csv"), row.names = FALSE)

cat("Done! Output directory: ", normalizePath(outdir), "\n",
    " - Single plots: TPC_aw_<aw>_Briere_vs_SS.png\n",
    " - Grid: TPC_aw_grid_2x3.png\n",
    " - Table 1: Table1_aw_model_comparison.csv\n", sep = "")
