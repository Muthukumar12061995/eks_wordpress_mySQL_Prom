resource "aws_eks_cluster" "eks" {
  name = "${local.cluster_name}"
  version = local.eks_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    #  EKS control plane is accessible only from within the VPC.
    endpoint_private_access = true
    #  EKS control plane is accessible over internet
    endpoint_public_access = true

    /*
     Where to deploy worker nodes those subnet
     must be in alteast two different azs
    */ 
    subnet_ids = [
      # Private worker node 
        aws_subnet.private_zone1.id,
        aws_subnet.private_zone2.id,
      # Public worker node
        #aws_subnet.public_zone1.id,
        #aws_subnet.public_zone2.id
    ]

    /* 
    EKS will create cross account ENI (on above subnets) to establish 
    communication between controlPlane running on AWS VPC
    to your VPC worker nodes
    */
  }

  access_config {
    authentication_mode = "API"
    # add user used to create cluster with admin permission(cluster admin) 
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [ aws_iam_role_policy_attachment.eks ]
}

