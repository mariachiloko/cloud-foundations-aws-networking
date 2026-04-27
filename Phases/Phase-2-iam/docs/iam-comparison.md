# IAM Comparison: Manual vs Terraform

## Overview

In this phase, IAM resources were created both manually in the AWS Console and using Terraform. This comparison highlights the differences between both approaches and explains why Infrastructure as Code (IaC) is the preferred method in real-world environments.

---

## Manual IAM vs Terraform IAM

| Category | Manual IAM (AWS Console) | Terraform IAM |
|--------|--------------------------|----------------|
| Consistency | Prone to human error | Consistent and repeatable |
| Visibility | Hard to track changes | Full visibility via code |
| Version Control | None | Integrated with Git |
| Scalability | Poor | Designed for scale |
| Auditability | Limited | Easily reviewable |
| Risk | High (manual mistakes) | Lower (review + automation) |

---

## When to Use Each

### Manual IAM
Used for:
- Learning IAM concepts
- Debugging permission issues
- Quick testing or experimentation

---

### Terraform IAM
Used for:
- Production environments
- Repeatable deployments
- Team collaboration
- Enforcing consistent security practices

---

## Configuration Drift

### What is Drift?

Configuration drift occurs when:
- Infrastructure is changed manually in AWS
- Terraform configuration no longer matches actual resources

---

### Example

- A role is created in Terraform
- Someone modifies the role manually in AWS
- Terraform state is now out of sync

---

### Detection

Drift is detected during:
terraform plan 

---

### Resolution

Terraform will:
- Identify differences
- Attempt to restore the infrastructure to the defined configuration

---

## OIDC Authentication (GitHub → AWS)

### Problem (Old Approach)

- GitHub workflows required stored AWS credentials
- Risk of credential leakage
- Difficult to manage securely

---

### Solution (OIDC)

OIDC allows GitHub to authenticate securely using temporary tokens.

---

### Authentication Flow

1. GitHub workflow starts
2. GitHub requests an OIDC token
3. Token contains identity claims (repository, branch)
4. GitHub sends token to AWS
5. AWS verifies token against IAM role trust policy
6. If valid → role is assumed
7. AWS returns temporary credentials
8. Terraform runs using those credentials

---

### Benefits

- No stored credentials
- Temporary access only
- Reduced security risk
- Aligns with modern cloud best practices

---

## IAM Design Decisions

### Roles Over Users

Roles were used instead of users because:
- They provide temporary credentials
- They are not tied to a single identity
- They reduce the risk of credential exposure

---

### Least Privilege

Policies were designed to:
- Grant only required permissions
- Avoid unnecessary access
- Reduce blast radius in case of compromise

---

### Trust Policy vs Permission Policy

- Trust Policy
  - Defines who can assume the role
  - Used in OIDC to allow GitHub access

- Permission Policy
  - Defines what actions are allowed
  - Controls access to AWS resources

Both must be correctly configured for IAM to function properly.

---

## Key Takeaways

- Manual IAM is useful for learning and debugging
- Terraform is required for scalable, production environments
- Configuration drift is a real risk when mixing manual and IaC changes
- OIDC eliminates the need for long-lived AWS credentials
- Roles and least privilege are critical for secure design
