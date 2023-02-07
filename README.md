# AWS Terraform

## Commands

### Deploy
```
terraform plan
```

```
terraform apply -auto-approve
```

```
terraform apply -refresh-only -auto-approve
```

```
terraform destroy -auto-approve
```

### Output
```
terraform output
```

### Format
```
terraform fmt
```

### Info
```
terraform state list
```

```
terraform state show [target]
```

```
terraform show
```

### Console
```
terraform console
```

### Environment variables
```
terraform [command] -var="env_name=dev"
```
```
terraform [command] -var-file="terraform.tfvars"
```
