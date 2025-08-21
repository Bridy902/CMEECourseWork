# =========================================================
# Species TPCs: Briere-2 vs Sharpe–Schoolfield (low-temp)
# Outputs:
#   results/Table_species_model_comparison.csv
#   figs_tpc/TPC_species_grid.png  (+ optional per-species PNGs)
# =========================================================

rm(list = ls()); graphics.off(); set.seed(42)
need <- c("dplyr","readr","ggplot2","patchwork")
to_install <- setdiff(need, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, quiet = TRUE)
suppressPackageStartupMessages({ lapply(need, require, character.only = TRUE) })

# ---------- input ----------
csv <- "species_temperature_mean_growth.csv"
if (!file.exists(csv)) stop("CSV not found: ", csv)
df <- readr::read_csv(csv, show_col_types = FALSE)
names(df) <- tolower(gsub("\\s+","_", names(df)))
stopifnot(all(c("species","temperature","mean_growth_rate") %in% names(df)))

species_list <- sort(unique(df$species))

# ---------- model functions ----------
briere_fun <- function(T, a, T0, Tmax){
  a * T * (T - T0) * sqrt(pmax(0, Tmax - T))
}
k_B  <- 8.617e-5; Tref <- 293.15
ss_low_fun <- function(Tk, B0, E, El, Tl){
  num <- B0 * exp(-E / k_B * (1/Tk - 1/Tref))
  den <- 1 + exp(El / k_B * (1/Tk - 1/Tl))
  num / den
}

# ---------- base-nls multistart fitters (no bounds) ----------
fit_briere_one_nls <- function(dat){
  dat <- dat[order(dat$temperature), ]
  T <- dat$temperature; y <- dat$mean_growth_rate
  a_grid    <- 10^seq(-8, -3, length.out = 6)
  T0_grid   <- seq(min(T) - 10, min(T) - 1, length.out = 5)
  Tmax_grid <- seq(max(T) + 1,  max(T) + 10, length.out = 5)
  best <- NULL
  for (a0 in a_grid) for (T0 in T0_grid) for (Tmax in Tmax_grid) {
    if (T0 >= min(T) || Tmax <= max(T) || T0 >= Tmax) next
    try({
      m <- nls(y ~ briere_fun(T, a, T0, Tmax),
               start = list(a = a0, T0 = T0, Tmax = Tmax),
               control = nls.control(maxiter = 500, warnOnly = TRUE))
      rss <- sum(resid(m)^2)
      if (is.null(best) || rss < best$rss) best <- list(mod = m, rss = rss)
    }, silent = TRUE)
  }
  if (is.null(best)) return(NULL) else best$mod
}

fit_ss_low_one_nls <- function(dat){
  dat <- dat[order(dat$temperature), ]
  Tk <- dat$temperature + 273.15
  y  <- dat$mean_growth_rate
  ybar <- mean(y, na.rm = TRUE); ymax <- max(y, na.rm = TRUE)
  B0_grid <- c(ybar, ymax, max(1e-6, 0.5*ybar))
  E_grid  <- c(0.4, 0.6, 0.8)
  El_grid <- c(0.5, 1.0, 2.0)
  Tl_grid <- seq(min(Tk)-10, min(Tk)+5, length.out = 6)
  best <- NULL
  for (B0 in B0_grid) for (E in E_grid) for (El in El_grid) for (Tl in Tl_grid){
    if (Tl >= min(Tk)) next
    try({
      m <- nls(y ~ ss_low_fun(Tk, B0, E, El, Tl),
               start = list(B0=B0, E=E, El=El, Tl=Tl),
               control = nls.control(maxiter = 600, warnOnly = TRUE))
      rss <- sum(resid(m)^2)
      if (is.null(best) || rss < best$rss) best <- list(mod=m, rss=rss)
    }, silent = TRUE)
  }
  if (is.null(best)) return(NULL) else best$mod
}

# ---------- fit all species ----------
fits_briere <- list(); fits_ssl <- list()
for (sp in species_list){
  di <- df |> dplyr::filter(species == sp)
  fits_briere[[sp]] <- fit_briere_one_nls(di)
  fits_ssl   [[sp]] <- fit_ss_low_one_nls(di)
  cat("Fitted:", sp,
      "| Briere-2:", ifelse(is.null(fits_briere[[sp]]),"fail","OK"),
      "| SS low-temp:", ifelse(is.null(fits_ssl[[sp]]),"fail","OK"), "\n")
}

# ---------- model-comparison table ----------
metrics <- function(y, yhat, k){
  rss <- sum((y - yhat)^2); tss <- sum((y - mean(y))^2)
  n <- length(y)
  R2 <- 1 - rss/tss
  AIC <- n*log(rss/n) + 2*k
  RMSE <- sqrt(mean((y - yhat)^2))
  list(R2=R2, RMSE=RMSE, AIC=AIC)
}
rows <- dplyr::bind_rows(lapply(species_list, function(sp){
  di <- df |> dplyr::filter(species==sp) |> dplyr::arrange(temperature)
  T <- di$temperature; y <- di$mean_growth_rate

  r_b <- if (!is.null(fits_briere[[sp]])){
    c0 <- coef(fits_briere[[sp]])
    yhat <- briere_fun(T, c0[["a"]], c0[["T0"]], c0[["Tmax"]])
    m <- metrics(y, yhat, k=length(c0))
    data.frame(species=sp, model="Briere-2", R2=m$R2, RMSE=m$RMSE, AIC=m$AIC)
  } else data.frame(species=sp, model="Briere-2", R2=NA, RMSE=NA, AIC=Inf)

  r_s <- if (!is.null(fits_ssl[[sp]])){
    c1 <- coef(fits_ssl[[sp]])
    yhat <- ss_low_fun(T+273.15, c1[["B0"]], c1[["E"]], c1[["El"]], c1[["Tl"]])
    m <- metrics(y, yhat, k=length(c1))
    data.frame(species=sp, model="SS low-temp", R2=m$R2, RMSE=m$RMSE, AIC=m$AIC)
  } else data.frame(species=sp, model="SS low-temp", R2=NA, RMSE=NA, AIC=Inf)

  rbind(r_b, r_s)
}))
tbl <- rows |>
  dplyr::group_by(species) |>
  dplyr::mutate(deltaAIC = AIC - min(AIC, na.rm=TRUE),
                aic_w    = exp(-0.5*deltaAIC)/sum(exp(-0.5*deltaAIC)),
                winner   = ifelse(deltaAIC==0,"best","")) |>
  dplyr::ungroup() |>
  dplyr::arrange(species, model)

dir.create("results", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(tbl, file.path("results","Table_species_model_comparison.csv"))
cat("Saved: results/Table_species_model_comparison.csv\n")

# ---------- predictions for plotting (only within observed window) ----------
pred_df <- dplyr::bind_rows(lapply(species_list, function(sp){
  di <- df |> dplyr::filter(species==sp)
  Tmin <- min(di$temperature); Tmax <- max(di$temperature)
  Tseq <- seq(Tmin-0.5, Tmax+0.5, by=0.1)

  b <- fits_briere[[sp]]
  s <- fits_ssl   [[sp]]

  pb <- if (is.null(b)) rep(NA_real_, length(Tseq)) else {
    co <- coef(b); briere_fun(Tseq, co[["a"]], co[["T0"]], co[["Tmax"]])
  }
  ps <- if (is.null(s)) rep(NA_real_, length(Tseq)) else {
    co <- coef(s); ss_low_fun(Tseq+273.15, co[["B0"]], co[["E"]], co[["El"]], co[["Tl"]])
  }

  rbind(
    data.frame(species=sp, temperature=Tseq, pred=pb, model="Briere-2"),
    data.frame(species=sp, temperature=Tseq, pred=ps, model="SS low-temp")
  )
}))

# ---------- plot grid ----------
pal <- c("Briere-2"="#2E86DE", "SS low-temp"="#E17055")
pretty_theme <- function(base_size=13){
  theme_minimal(base_size = base_size) +
    theme(plot.title = element_text(face="bold", hjust=0.5, margin=margin(b=6)),
          axis.title.x = element_text(margin=margin(t=8)),
          axis.title.y = element_text(margin=margin(r=8)),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(linewidth=0.25, colour="grey85"),
          legend.position = "bottom", legend.title = element_blank(),
          plot.margin = margin(8,12,8,12))
}
dir.create("figs_tpc", showWarnings = FALSE, recursive = TRUE)

plots <- lapply(species_list, function(sp){
  pts  <- df      |> dplyr::filter(species==sp)
  line <- pred_df |> dplyr::filter(species==sp, !is.na(pred))
  Tmin <- min(pts$temperature); Tmax <- max(pts$temperature)
  line <- line |> dplyr::filter(temperature >= Tmin-0.5, temperature <= Tmax+0.5)

  ggplot() +
    geom_point(data=pts, aes(temperature, mean_growth_rate),
               shape=21, size=3.0, stroke=0.8, colour="grey20", fill="white") +
    geom_line(data=line, aes(temperature, pred, colour=model),
              linewidth=1.25, lineend="round") +
    scale_color_manual(values=pal) +
    coord_cartesian(xlim=c(Tmin-0.5, Tmax+0.5)) +
    labs(title=sp, x="Temperature (°C)", y="Mean growth rate (mm/day)") +
    pretty_theme(13)
})

grid <- patchwork::wrap_plots(plots, ncol=3) +
  patchwork::plot_layout(guides="collect") & theme(legend.position="bottom")
ggsave(file.path("figs_tpc","TPC_species_grid.png"), grid, width=14, height=9, dpi=320)
cat("Saved: figs_tpc/TPC_species_grid.png\n")
