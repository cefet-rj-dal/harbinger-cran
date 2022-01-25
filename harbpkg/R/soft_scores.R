soft_scores <- function(detection, events, k=15){

  E <- which(events)
  m <- length(E)

  D <- which(detection)
  n <- length(D)

  mu <- function(j,i,E,D,k) max(min( (D[i]-(E[j]-k))/k, ((E[j]+k)-D[i])/k ), 0)

  Mu <- matrix(NA,nrow = n, ncol = m)
  for(j in 1:m) for(i in 1:n) Mu[i,j] <- mu(j,i,E,D,k)

  E_d <- list()
  for(i in 1:n) E_d[[i]] <- which(Mu[i,] == max(Mu[i,]))

  D_e <- list()
  for(j in 1:m) D_e[[j]] <- which(sapply(1:n, function(i) j %in% E_d[[i]] & Mu[i,j] > 0))

  d_e <- c()
  for(j in 1:m) {
    if(length(D_e[[j]])==0) d_e[j] <- NA
    else d_e[j] <- D_e[[j]][which.max(sapply(D_e[[j]], function(i) Mu[i,j]))]
  }

  S_e <- c()
  for(j in 1:m) {
    if(length(D_e[[j]])==0) S_e[j] <- NA
    #else S_e[j] <- sum(sapply(D_e[[j]], function(i) Mu[i,j])) / length(D_e[[j]]) #mean
    else S_e[j] <- max(sapply(D_e[[j]], function(i) Mu[i,j]))  #max
  }

  S_d <- c()
  for(i in 1:n) S_d[i] <- max(S_e[which(d_e == i)], 0)

  return(S_d)
}
