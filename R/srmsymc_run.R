#' @title Run srmsymc
#' 
#' @description Run the ADM srmsymc program
#' 
#' @export
#' 
#' @author Einar Hjorleifsson <einar.hjorleifsson@gmail.com>
#' 
#' @param sr integer. containg the stock-recruitment model
#' @param opt_sen XXX
#' @param opt_pen XXX
#' @param nits Number of iterations of bootstrapping - if 0, does only the deterministic fit
#' @param path characters. Name of the directory for storing the output. If
#' missing, the output remains in the working directory.
#' @param output boolean. If FALSE (default) no results (*.dat) files are returned.
#' @param windose boolean for operating system, winows vs unix-like


srmsymc_run <- function(sr,opt_sen=1,opt_pen=1,nits=100,path,output=FALSE,windose=TRUE) {
  
  # check if file exists
  #if (!file.exists('srmsymc')) srmsymc_compile()
  if (!file.exists('srmsymc.dat')) stop('The srmsymc.dat file must be in the working directory')
  if (!file.exists('age.dat')) stop('The age.dat file must be in the working directory')
  
  # update the .dat file
  # Update the recruitment model number
  x <- readLines("srmsymc.dat")
  i <- grep("# Ropt:   S-R function type",x)
  x[i] <- paste(sr,"  # Ropt:   S-R function type")
  # Update the options
  i <- grep("# senopt", x)
  x[i] <- paste(opt_sen,"# senopt")
  i <- grep("# penopt", x)
  x[i] <- paste(opt_pen,"# penopt")
  write(x,file="srmsymc.dat")
    
  tmpfile = file("sim.dat","w")
  cat('21 1 ', nits, "\n", sep="", file = tmpfile)
  close(tmpfile)
  
  if(windose) {
    system(paste('srmsymc.exe -mcmc', (nits+11)*10000, '-mcsave 10000 -nosdmcmc'))
    system("srmsymc.exe -mceval")
  } else {
    system(paste('srmsymc -mcmc', (nits+11)*10000, '-mcsave 10000 -nosdmcmc'))
    system("srmsymc -mceval")
  }
  #if(!missing(path)) {
    
  #  if (!file.exists(path)) {
  #    cmd <- paste("mkdir",path)
  #    system(cmd)
  #  }
    
  #  cmd <- paste("cp *.dat ",path,"/.",sep="")
  #  system(cmd)
  #}
  
  #if(output) {
  #  x <- list()
  #  x$par <- srmsymc_read_par()
  #  x$yield <- srmsymc_read_yield()
  #  x$ssb <- srmsymc_read_ssb()
  #  return(x)
  #}
  
  # TODO: clean directory
}

