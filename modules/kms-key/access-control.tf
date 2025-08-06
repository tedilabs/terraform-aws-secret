###################################################
# Key Policy for Customer Managed Key
###################################################

resource "aws_kms_key_policy" "this" {
  count = try(length(jsondecode(data.aws_iam_policy_document.this.json)["Statement"]) > 0 ? 1 : 0, 0)

  key_id = aws_kms_key.this.key_id

  policy                             = data.aws_iam_policy_document.this.json
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [
    data.aws_iam_policy_document.predefined.json,
  ]
  override_policy_documents = var.policy != null ? [var.policy] : null
}

data "aws_iam_policy_document" "predefined" {
  # Key owner - all key operations
  dynamic "statement" {
    for_each = length(var.predefined_roles.owners) > 0 ? ["go"] : []

    content {
      sid       = "KeyOwner"
      actions   = ["kms:*"]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.owners
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators
  dynamic "statement" {
    for_each = length(var.predefined_roles.administrators) > 0 ? ["go"] : []

    content {
      sid = "KeyAdministration"
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:ReplicateKey",
        "kms:ImportKeyMaterial",
        "kms:RotateKeyOnDemand"
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.administrators
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users
  dynamic "statement" {
    for_each = length(var.predefined_roles.users) > 0 ? ["go"] : []

    content {
      sid = "KeyUsage"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.users
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration
  dynamic "statement" {
    for_each = length(var.predefined_roles.service_users) > 0 ? ["go"] : []

    content {
      sid = "KeyServiceUsage"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.service_users
      }

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = [true]
      }
    }
  }

  ## Key cryptographic operations
  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto
  dynamic "statement" {
    for_each = length(var.predefined_roles.symmetric_encryption) > 0 ? ["go"] : []

    content {
      sid = "KeySymmetricEncryption"
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:ReEncrypt*",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.symmetric_encryption
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.predefined_roles.asymmetric_encryption) > 0 ? ["go"] : []

    content {
      sid = "KeyAsymmetricPublicEncryption"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:DescribeKey",
        "kms:GetPublicKey",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.asymmetric_encryption
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.predefined_roles.asymmetric_signing) > 0 ? ["go"] : []

    content {
      sid = "KeyAsymmetricSignVerify"
      actions = [
        "kms:DescribeKey",
        "kms:GetPublicKey",
        "kms:Sign",
        "kms:Verify",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.asymmetric_signing
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.predefined_roles.hmac) > 0 ? ["go"] : []

    content {
      sid = "KeyHMAC"
      actions = [
        "kms:DescribeKey",
        "kms:GenerateMac",
        "kms:VerifyMac",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.predefined_roles.hmac
      }
    }
  }
}
