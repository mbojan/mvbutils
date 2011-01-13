\name{install.pkg}
\alias{install.pkg}
\alias{build.pkg}
\alias{build.pkg.binary}
\alias{check.pkg}
\alias{set.rcmd.vars}
\title{Package building, distributing, and checking}
\description{These are convenient wrappers for R{}'s package creation and installation tools. They are designed to be used on packages created from tasks via \code{mvbutils}. However, the \code{mvbutils} approach deliberately makes re-installation a rare event, and one call to \code{install.pkg} might suffice for the entire life of a simple package. After that very first installation, you'd probably only need to call \code{install.pkg} if (when\dots{}) new versions of R{} entail re-installation of packages, and \code{build.pkg/build.pkg.binary/check.pkg} when you want to give your package to others, either directly or via CRAN etc. Set the argument \code{intern=F} if you want to see progress on-screen (but the result won't be captured); if you can handle the disconcertingly blank wait, set \code{intern=T} to get a character vector result. \code{set.rcmd.vars} is not working yet, but that probably doesn't matter; it is supposed to tell R{} how to temporarily set any environment variables needed for these processes, but most users will already have the variables set appropriately and won't need to bother with \code{set.rcmd.vars} anyway.
}
\usage{
  install.pkg( pkg, character.only=FALSE, dir.above.source='+', lib=.libPaths()[1], intern=TRUE)
  build.pkg( pkg, character.only=FALSE, dir.above.source='+', intern=TRUE)
  build.pkg.binary( pkg, character.only=FALSE, dir.above.source='+', intern=TRUE)
  check.pkg( pkg, character.only=FALSE, dir.above.source='+', intern=TRUE)
  set.rcmd.vars( ...) # doesn't set anything until the above are actually run, and then only temporarily
}
\arguments{
\item{ pkg}{usually an unquoted package name, but interpretation can be changed by non-default \code{character.only}}
\item{ character.only}{default FALSE. If TRUE, treat \code{pkg} as a normal object, which should therefore be a string containing the package's name. If \code{character.only} is itself a string, it will override \code{pkg} and be treated as the name of the package.}
\item{ dir.above.source}{where to look for source package; see \code{\link{pre.install}}}
\item{ intern}{?return the result as a character vector? (See \code{\link{system}}) Set to FALSE if you want to see the output as-it-happens, but in that case it won't be returned.}
\item{ lib}{where to install to}
\item{ ...}{name-value pairs of system environment variables}
}
\details{
Before doing any of this, you need to have used \code{\link{pre.install}} to create a source package. (Or \code{\link{patch.install}}, if you've done all this before and just want to re-install/build/check for some reason.)

You may also have to set some environment variables (eg PATH, and perhaps R_LIBS) for the underlying R{} CMD calls to work. (Or you may not-- if you have set them R-appropriately before your R{} session, then there is nothing to worry about. The reason I personally do worry, is that the "mingw" utilities conflict with some long-standing Windows commands such as "find", which breaks various batch files that I often use. So I only use the R-appropriate version of PATH when I have to.) Rather than having to remember every time what these settings should be, you can call \code{set.rcmd.vars} once per session, eg in your \code{.First}. This will \emph{not} change the environment variables in the rest of the R{} session; the changes are only temporary, while \code{build.pkg} etc are running. On my system (Windows XP 32-bit), for example, I currently have to temporarily set PATH as follows when doing R{} builds:

PATH = C:\\Rtools\\bin;c:\\perl\\bin;c:\\rtools\\mingw\\bin;\%LATEX\%\\BIN;\%R_LATEST\%\\BIN\\i386;\%PATH\%

Note that environment variables will be substituted, but currently only for Windows (I don't know how to, elsewhere).

\code{install.pkg} calls "R CMD INSTALL" to install from a source package.

\code{build.pkg} calls "R CMD build" to wrap up the source package into a "tarball", as required by CRAN and also for distribution to non-Windows-and-Mac platforms.

\code{build.pkg.binary} (Windows & Mac only) calls "R CMD INSTALL --build" to generate a binary package. A temporary installation directory is used, so your existing installation is \emph{not} overwritten or deleted if there's a problem; R{} CMD INSTALL --build has a nasty habit of doing just that unless you're careful, which \code{build.pkg.binary} is.

\code{check.pkg} calls "R CMD check" after first calling \code{build.pkg} (more efficiently, I should perhaps try to work out whether there's an up-to-date tarball already). I should probably allow control of the plethora of checks via appropriate flags, perhaps via the pre-install-hook somehow. However, my understanding that CRAN insists on the full monty, regardless of what you think makes sense for your package. [It \emph{may} also be possible to do some checks directly from R{} via functions in the \pkg{utils} package, but NB the possibility of interference with your current R{} session; for example, \code{codoc} attempts to unload & load the package.]
}
\value{If \code{intern=TRUE}: the stuff printed out, with class \code{cat} so it prints nicely. If \code{intern=FALSE}, various things about the paths (purely for my programming convenience).
}
\examples{
\dontrun{
install.pkg( mvbutils)
build.pkg( mvbutils)
check.pkg( mvbutils)
}
}
\keyword{misc}