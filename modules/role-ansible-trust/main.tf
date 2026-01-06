# Define the Trust Relationship 
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "AWS"
      # This is the "Principal" - the Automation Account root
      identifiers = ["arn:aws:iam::${var.automation_account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy" "ansible_ssm_execution" {
  name = "AnsibleSSMExecution"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:StartSession",
          "ssm:DescribeDocument",
          "ssm:GetDocument",
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:ec2:us-east-1:315735600075:instance/*",
          "arn:aws:ssm:us-east-1::document/AWS-StartSSMSession",
          "arn:aws:ssm:us-east-1:*:document/*",
          "arn:aws:s3:::jr-ansible-transfer-315735600075-dev",
          "arn:aws:s3:::jr-ansible-transfer-315735600075-dev/*",
          "arn:aws:ssm:us-east-1:315735600075:managed-instance/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ],
        Resource = ["arn:aws:ssm:*:*:session/$${aws:username}-*"]
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name               = "AnsibleInventoryRole"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "ec2_readonly" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
