###################################################
# Grants for Customer Managed Key
###################################################

resource "aws_kms_grant" "this" {
  for_each = {
    for grant in var.grants :
    grant.name => grant
  }

  region = var.region

  key_id = aws_kms_key.this.key_id

  name              = each.key
  grantee_principal = each.value.grantee_principal
  operations        = each.value.operations

  retiring_principal    = each.value.retiring_principal
  retire_on_delete      = each.value.retire_on_delete
  grant_creation_tokens = each.value.grant_creation_tokens

  dynamic "constraints" {
    for_each = each.value.constraints != null ? [each.value.constraints] : []

    content {
      encryption_context_equals = (constraints.value.type == "ENCRYPTION_CONTEXT_EQUALS"
        ? constraints.value.value
        : null
      )
      encryption_context_subset = (constraints.value.type == "ENCRYPTION_CONTEXT_SUBSET"
        ? constraints.value.value
        : null
      )
    }
  }
}


###################################################
# Key Policy for Customer Managed Key
###################################################

resource "aws_kms_key_policy" "this" {
  count = try(length(jsondecode(data.aws_iam_policy_document.this.json)["Statement"]) > 0 ? 1 : 0, 0)

  region = var.region

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
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "OWNER"
    ]
    iterator = policy

    content {
      sid       = "KeyOwner${policy.key}"
      actions   = ["kms:*"]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators
  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "ADMINISTRATOR"
    ]
    iterator = policy

    content {
      sid = "KeyAdministration${policy.key}"
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
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users
  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "USER"
    ]
    iterator = policy

    content {
      sid = "KeyUsage${policy.key}"
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
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration
  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "SERVICE_USER"
    ]
    iterator = policy

    content {
      sid = "KeyServiceUsage${policy.key}"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = policy.value.iam_entities
      }

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = [true]
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  ## Key cryptographic operations
  # INFO: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto
  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "SYMMETRIC_ENCRYPTION"
    ]
    iterator = policy

    content {
      sid = "KeySymmetricEncryption${policy.key}"
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
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "ASYMMETRIC_ENCRYPTION"
    ]
    iterator = policy

    content {
      sid = "KeyAsymmetricPublicEncryption${policy.key}"
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
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "ASYMMETRIC_SIGNING"
    ]
    iterator = policy

    content {
      sid = "KeyAsymmetricSignVerify${policy.key}"
      actions = [
        "kms:DescribeKey",
        "kms:GetPublicKey",
        "kms:Sign",
        "kms:Verify",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = [
      for policy in var.predefined_policies :
      policy
      if policy.role == "HMAC"
    ]
    iterator = policy

    content {
      sid = "KeyHMAC${policy.key}"
      actions = [
        "kms:DescribeKey",
        "kms:GenerateMac",
        "kms:VerifyMac",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = policy.value.iam_entities
      }

      dynamic "condition" {
        for_each = policy.value.conditions

        content {
          variable = condition.value.key
          test     = condition.value.condition
          values   = condition.value.values
        }
      }
    }
  }
}
