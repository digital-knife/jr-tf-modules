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

resource "aws_iam_role" "this" {
  name               = "AnsibleInventoryRole"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "ec2_readonly" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
