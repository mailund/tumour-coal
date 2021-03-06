
#' Simulate the coalescence times for a single tumour.
#' 
#' Simulate coalescence times for a tumor based on a birth/death process
#' with birth rate lambda and death rate mu. The simulation uses
#' scaled parameters delta = lambda - mu and gamma = (lambda-mu)/(lambda*rho)
#' where rho is the fraction of tumor cells sequenced.
#' 
#' See Wiuf's note for details.
#' 
#' The function will return \code{n} time points, where t1 is the time for the 
#' driver mutation and the remaining are the actual coalescence times for samples
#' from the tumor.
#' 
#' @param n      The number of coalescence times.
#' @param delta  Parameter for the birth/death process.
#' @param gamma  Parameter for the birth/death process.
#' 
#' @export
coaltimes.single <- function(n, delta, gamma) {
  Us <- sort(runif(n))
  -log( Us / (gamma + (1-gamma) * Us) ) / delta
}


#' Simulate the coalescence times for a single tumour conditional on T1.
#' 
#' This simulates coalescence times within a tumour conditional on the time of the
#' driver mutation t1. It follows (S5) in Wiuf's notes.
#' 
#' The function will return \code{n-1} time points. These are the coalescence times
#' within the tumour, and not including the driver mutation (which is t1), unlike
#' the function \code{coaltimes.single}.
#' 
#' @param n      The number of coalescence times.
#' @param delta  Parameter for the birth/death process.
#' @param gamma  Parameter for the birth/death process.
#' @param t1     Time of the driver mutation.
#' 
#' @export
coaltimes.single.conditional <- function(n, delta, gamma, t1) {
  x1 <- gamma*exp(-delta*t1) / (1 - exp(-delta*t1))
  Us <- rev(sort(runif(n-1)))
  Zs <- Us / (1 + x1)
  - log( (1-Zs) / (1 - (1-gamma)*Zs)) / delta
}

#' Takes coalescence times \code{t[1],t[2],t[3],...,t[n]} and changes them into
#' delta times \code{t[1],t[2]-t[1], t[3]-t[2],...,t[n]-t[n-1]}
#' 
#' This transformation is necessary when simulating with \code{rcoal} that wants
#' the differences in times rather than the absolute coalescence times.
#' 
#' @param ts   The coalescence times.
#' 
#' @export
coaltimes.differences <- function(ts) {
  ts - c(0, ts[-length(ts)])
}