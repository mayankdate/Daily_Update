# ============================================================
# Smart folder tree generator
# Builds a readable tree and RETURNS it as a character vector
# (one line per element) so it can be printed, written to a
# file, or copied with clipr::write_clip().
#
# Every folder is shown. What gets summarized instead of listed:
#   - contents of noisy folders (.venv, .git, node_modules, ...)
#   - bulk media (images, videos, audio) -> shown as counts
# ============================================================

library(fs)
library(stringr)

# ---- Settings ----
target_dir <- dirname(dirname(rstudioapi::getActiveDocumentContext()$path))

max_files_listed <- 20                  # per folder: list files up to this many, then summarize the rest

# Standard folders shown as a single leaf line — not descended into, not counted.
# Their internals never carry structural value worth expanding.
noexpand_dirs <- c(
  ".venv", "venv", "env", ".env", ".git", ".svn", "node_modules",
  "__pycache__", ".Rproj.user", ".idea", ".vscode",
  "renv", ".cache", "build", "dist", ".mypy_cache", ".pytest_cache",
  ".ipynb_checkpoints", "packrat", ".quarto"
)

# Extensions summarized as counts rather than listed
bulk_groups <- list(
  images = c("jpg", "jpeg", "png", "gif", "bmp", "tif", "tiff",
             "heic", "webp", "raw", "cr2", "nef", "arw", "dng"),
  videos = c("mp4", "mov", "avi", "mkv", "wmv", "flv", "m4v", "mpg", "mpeg"),
  audio  = c("mp3", "wav", "flac", "aac", "ogg", "m4a")
)

# ---- Helpers ----
ext_of <- function(paths) str_to_lower(path_ext(paths))

group_of <- function(ext) {
  for (g in names(bulk_groups)) if (ext %in% bulk_groups[[g]]) return(g)
  NA_character_
}

# Summarize a set of file paths into "[group: N files -- 3 jpg, 1 png]" lines
bulk_summary_lines <- function(paths) {
  exts <- vapply(paths, ext_of, character(1))
  grps <- vapply(exts, group_of, character(1))
  out <- character(0)
  for (g in unique(grps[!is.na(grps)])) {
    tab <- table(exts[!is.na(grps) & grps == g])
    breakdown <- paste(sprintf("%d %s", tab, names(tab)), collapse = ", ")
    out <- c(out, sprintf("[%s: %d files -- %s]", g, sum(grps == g, na.rm = TRUE), breakdown))
  }
  out
}

# ---- Recursive builder: returns character vector of lines ----
build_tree <- function(dir, prefix = "") {
  entries <- dir_ls(dir, all = TRUE, fail = FALSE)
  entries <- entries[!path_file(entries) %in% c(".", "..")]
  dirs  <- sort(entries[is_dir(entries)])
  files <- sort(entries[is_file(entries)])
  
  file_grp     <- vapply(files, function(f) group_of(ext_of(f)), character(1))
  normal_files <- files[is.na(file_grp)]
  bulk_files   <- files[!is.na(file_grp)]
  
  # Files that get an actual line (normal ones, capped)
  listed_files <- normal_files
  overflow_line <- character(0)
  if (length(normal_files) > max_files_listed) {
    listed_files  <- normal_files[seq_len(max_files_listed)]
    overflow_line <- sprintf("... and %d more files", length(normal_files) - max_files_listed)
  }
  
  # Synthetic (non-path) lines to append after real entries at this level
  extra_lines <- c(overflow_line, if (length(bulk_files)) bulk_summary_lines(bulk_files))
  
  # Ordered items: real dirs, real files, then synthetic summary strings
  items    <- c(as.list(dirs), as.list(listed_files), as.list(extra_lines))
  is_synth <- c(rep(FALSE, length(dirs) + length(listed_files)), rep(TRUE, length(extra_lines)))
  
  lines <- character(0)
  n <- length(items)
  for (i in seq_len(n)) {
    item      <- items[[i]]
    is_last   <- i == n
    connector <- if (is_last) "\u2514\u2500\u2500 " else "\u251c\u2500\u2500 "
    child_pfx <- if (is_last) paste0(prefix, "    ") else paste0(prefix, "\u2502   ")
    
    if (is_synth[i]) {
      lines <- c(lines, paste0(prefix, connector, item))
    } else if (is_dir(item)) {
      name <- path_file(item)
      if (name %in% noexpand_dirs) {
        lines <- c(lines, paste0(prefix, connector, name, "/"))
      } else {
        lines <- c(lines, paste0(prefix, connector, name, "/"))
        lines <- c(lines, build_tree(item, child_pfx))
      }
    } else {
      lines <- c(lines, paste0(prefix, connector, path_file(item)))
    }
  }
  lines
}

# ---- Run ----
if (!dir_exists(target_dir)) stop("Target folder does not exist: ", target_dir)

tree_lines <- c(paste0(path_file(target_dir), "/"), build_tree(target_dir))

# Print to console
cat(tree_lines, sep = "\n")

# Copy to clipboard (needs the clipr package). Paste into your doc.
clipr::write_clip(tree_lines)

# Or save to a file:
# writeLines(tree_lines, file.path(target_dir, "folder_tree.txt")