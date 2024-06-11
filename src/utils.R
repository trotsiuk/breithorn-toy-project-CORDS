# src/utils.R
library(git2r)

make_sha_filename <- function(basename, ext) {
  # Open the git-repository in the current directory
  repo <- repository(".")
  
  # Get the object ID of the HEAD commit
  head_commit <- revparse_single(repo, "HEAD")
  short_hash <- substr(head_commit$sha, 1, 10)
  
  # Check if there are uncommitted changes
  status <- status(repo)
  is_dirty <- length(status$staged) > 0 || length(status$unstaged) > 0 || length(status$untracked) > 0
  
  # Append "-dirty" if there are uncommitted changes
  if (is_dirty) {
    postfix <- paste0(short_hash, "-dirty")
  } else {
    postfix <- short_hash
  }
  
  return(paste0(basename, "-", format(Sys.Date(), format = "%Y%m%d"), "-", postfix, ".", ext))
}

