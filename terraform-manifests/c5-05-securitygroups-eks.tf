resource "aws_security_group" "eks_nodes_sg" {
	name        = "${local.name}-eks-nodes-sg"
	description = "EKS nodes SG used for quick testing (opens NodePort range)"
	vpc_id      = module.vpc.vpc_id

	ingress {
		description = "Allow NodePort range for testing"
		from_port   = 30000
		to_port     = 32767
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = local.common_tags
}