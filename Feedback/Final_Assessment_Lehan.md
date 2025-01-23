
# Final CMEE Bootcamp Assessment: Lehan

*Inconsistent directory naming convention at the top level...* 

## Week 1

  - A basic README was included, explaining folder purposes.
  - Logical folder structure: `Code`, `Data`, `Results`, and `Sandbox`.
  - `.gitignore` was missing in root repo's root directory.
  - Results folder contained generated files, violating best practices.
  - Weekly README file was missing!
  - Shell scripts (`tabtocsv.sh`, `csvtospace.sh`) were functional but lacked inline comments for clarity.

## Week 2
  - Weekly directory structure remained consistent.
  - The README in Week2 contained brief explanations of key scripts, improving usability.
  - `.gitignore` remained missing in the repository root.
  - Results folder was not entirely empty, though there was a reduction in clutter compared to Week 1.
- Some Python scripts, such as `align_seqs.py`, contained logical errors, which were noted and improved in subsequent weeks - good.
- Scripts showed more modularity and documentation, such as in `align_seqs_fasta.py` and `okas_debugme.py` (miss-spelling...).
- Errors like missing data files (`TestOaksData.csv`) were common, which caused scripts to fail without robust error handling.

## Week 3

  - README provided more detailed explanations, especially in the "code" folder.
  - Results folder contained output files (e.g., `Florida_Histogram.png`), which should be excluded from version control.
- Some R scripts lacked sufficient inline comments, reducing readability.

## Week 4

  - README provided a summary of Week4 tasks and context for files, including those related to the Florida practical.
  - Workflow was consistent, and previous feedback regarding organization showed improvement.
  - `.gitignore` was still missing despite prior recommendations, leading to potential clutter.
  - Larger files in the results folder increased the repository size unnecessarily.

## Week 4
- The `TreeHeight.R` script ran successfully, but error handling for invalid input was absent.
- `Florida.R` effectively visualized autocorrelation trends in Florida’s temperature data.
- Suggestions:
  - Include inline comments for better understanding of statistical methods.
  - Parameterize file paths and statistical tests to increase reusability.
  - LaTeX Report was too concise!
    - Suggestions:
      - Add a deeper discussion of the implications of autocorrelation trends.
      - Reference climate trends to provide context.
---

## Git Practices

- Commit messages were often generic (`modify`, `submission`), which hindered traceability.
- Repository size was manageable (1.84 MiB) but could have been reduced by cleaning up intermediate files.
- `.gitignore` remained missing throughout the coursework, despite earlier recommendations.
- Suggestions
  - Use detailed commit messages, e.g., "Added error handling to align_seqs.py".
  - Avoid committing binary files or intermediate outputs to keep the repository clean.

---

## Overall Assessment

Overall, a OK job, but much scope for improvement.

You showed some improvement across all aspects of the coursework, particularly in coding proficiency and workflow management, but more work to do on that front. Addressing the outlined suggestions will enhance the quality of future work.

Several scripts retained fatal errors - try to be a little more vigilant/persistent in chasing down and fixing errors in future. Your commenting needs to be more thorough, but this will improve with experience.

It was a tough set of weeks, but I believe your hard work in them has given you a great start towards further training, a quantitative masters dissertation, and ultimately a career in quantitative biology!

### (Provisional) Mark
 *58*