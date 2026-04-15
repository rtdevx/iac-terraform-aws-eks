cluster_name                         = "ekscluster"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
cluster_version                      = "1.35"                                     # ? Cluster Versions: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
cluster_endpoint_public_access       = true                                       # NOTE: Connectivity to Control Plane API via Public IP (to Amazon VPC)
cluster_endpoint_private_access      = false                                      # NOTE: Connectivity to Control Plane API via NAT Gateway (to Amazon VPC)
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]                              # NOTE: Access to Control Plane API from kubectl
eks_oidc_root_ca_thumbprint          = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280" # OPTIMIZE: It is possible to get the data from AWS. Not urgent (valid until 2037) but better practice.

# ! You must use a kubectl version that is within one minor version difference of your Amazon EKS cluster control plane ("cluster_version"). For example, a 1.34 kubectl client works with Kubernetes 1.33, 1.34, and 1.35 clusters.
# ? https://kubernetes.io/docs/tasks/tools/#kubectl
# ? https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html