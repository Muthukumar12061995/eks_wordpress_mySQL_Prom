resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.eks.name
  version = local.eks_version
  node_group_name = "general"
  node_role_arn = aws_iam_role.worker_node_role.arn

  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]
  #ami_type = ""
  capacity_type = "ON_DEMAND"
  instance_types = ["t2.large"]

  #We need to create cluster auto-scaler to make it work
  scaling_config {
    # target number of instances that you want the ASG to maintain under normal operating conditions
    desired_size = 5
    # baseline number of instances that must always be running
    max_size = 10
    # upper limit on the number of instances that the ASG can scale out to
    min_size = 3
  }
 
  # To enable ssh access to ec2 instance under node group
  # remote_access {
  #   ec2_ssh_key = aws_key_pair.ec2_ssh_key.key_name
  # }

  

  update_config {
    max_unavailable = 1
  }

  # we can use in POD affinity and Node Selectors
  labels = {
    role = "general"
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy
   ]

  # Allow external changes without Terraform plan difference

  lifecycle {
    ignore_changes = [ scaling_config[0].desired_size ]
  }
}