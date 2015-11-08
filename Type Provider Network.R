load("~/Dropbox/STAT992/DataSource/Dat.RData")
load("~/Dropbox/STAT992/DataSource/Et.RData")
setkey(Et, V1) #setkey for Et
head(Et)
setkey(Dat, NPI) #setkey for Dat
head(Dat)
tmp.link = Et[unique(Dat$NPI)] #link two data sets
tmp.link = tmp.link[complete.cases(tmp.link)] #only keep the complete cases
tmp.link = tmp.link[which(tmp.link$V2 %in% Dat$`NPI`)]
referral.matrix = as.matrix(tmp.link)[,1:2]
referral.undirected.graph = graph.edgelist(referral.matrix,directed=F)
referral.undirected.graph = simplify(referral.undirected.graph) #simplify the graph
features = colnames(Dat)[7]
ids = V(referral.undirected.graph)$name
tmp = Dat[ids, mult = "last"]
atbs = tmp[,features, with = F]
mean(complete.cases(atbs))
atbs = as.matrix(atbs)
for(i in 1:ncol(atbs)){
  referral.undirected.graph = set.vertex.attribute(referral.undirected.graph, name = colnames(atbs)[i],
                                                   index=V(referral.undirected.graph), value =  atbs[,i])
}

table(V(referral.undirected.graph)$`Provider Type`)
Type.names <- sort(unique(V(referral.undirected.graph)$`Provider Type`))
Type.nums <- V(referral.undirected.graph)$`Provider Type` %>% as.factor() %>% as.numeric()

Type.c <- contract.vertices(referral.undirected.graph, Type.nums)
E(Type.c)$weight <- 1  # It takes a looong time to run. 
Type.c <- simplify(Type.c)

Type.size <- as.vector(table(V(referral.undirected.graph)$`Provider Type`))
plot(Type.c, vertex.size=1/50*sqrt(Type.size),
     vertex.label=Type.names, vertex.color=V(Type.c),
     edge.width=sqrt(E(Type.c)$weight), vertex.label.dist=1, edge.arrow.size=0)
