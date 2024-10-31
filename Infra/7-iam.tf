
###########  EKS Cluster Role and Policy ##########

resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.cluster_name}-eks-cluster-role"
  assume_role_policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
      {
         "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  }
  )
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role.name
}

###########  EKS Worker Node Policy ##########

resource "aws_iam_role" "worker_node_role" {
  name = "${local.cluster_name}-eks-worker-node-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}

# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.worker_node_role.name
}

# To manage secondary IP's for the Pods

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.worker_node_role.name
}

# To provide read only access to ECR

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.worker_node_role.name
}

# Policy allows the EBS CSI driver to call AWS services on your behalf.
resource "aws_iam_policy" "ebs_csi_policy" {
  name = "${local.cluster_name}-ebs-csi-policy"
  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
        Action : [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceCreditSpecifications",
          "ec2:DescribeVolumeTypes",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ec2:ModifyVolume",
          "ec2:ModifyVolumeAttribute",
          "ec2:ModifyInstanceAttribute"
        ],
        Resource : "*",
        Effect : "Allow"
       }
      ]
    }
  )
}

# Attach the Policy to the EKS Worker Node Role: 
resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_policy" {
  role = aws_iam_role.worker_node_role.name
  policy_arn = aws_iam_policy.ebs_csi_policy.arn
}