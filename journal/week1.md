# Terraform Beginner Bootcamp 2023 - Week 1


## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kind of variables:
- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`
The `-var` flag is used to specify individual variables on the command line when running `terraform apply` or `terraform plan` commands. This is useful for passing variable values directly to Terraform without needing to store them in a file.

Here's an example usecase:
```bash
terraform apply -var="image_id=ami-abc123"
terraform apply -var='image_id_list=["ami-abc123","ami-def456"]' -var="instance_type=t2.micro"
terraform apply -var='image_id_map={"us-east-1":"ami-abc123","us-east-2":"ami-de
```

### var-file flag

The `var-file` option in Terraform is used to specify a file from which Terraform can read variable definitions. These files typically have the `.tfvars` or `.tfvars.json` extension and allow you to systematically manage variable assignments in a Terraform project.

The syntax to use var-file is as follows:
```bash
terraform apply -var-file="/path/variablefile.tfvars"
```

In this command, `/path/variablefile.tfvars` is the file that contains variable definitions.

If you want to use multiple `var-file` options, you can do so by including them one after the other. Terraform will consider all the variable definitions from these files. If there are any conflicts, the last definition will take precedence.

For example:
```bash
terraform apply -var-file=foo.tfvars -var-file=bar.tfvars
```

In this command, if both `foo.tfvars` and `bar.tfvars` define the same variable, the value from bar.tfvars will be used, as it is the last definition loaded.

You can also use the `-var` option in combination with the `var-file` option. The `-var` option allows you to set individual variables directly from the command line. If both `-var` and `-var-file` are used, the order in which they are provided matters. The last definition will override any previous ones.

For example:
```bash
terraform apply -var-file="/path/variablefile.tfvars" -var="location=us-east-1"
```

In this command, if `variablefile.tfvars` and the `-var` option both define the location variable, the value `us-east-1` will be used, as it is the last definition provided.

### terraform.tvfars

This is the default file to load in terraform variables in bulk

Terraform automatically loads `.tfvars` files only when they are named `terraform.tfvars` or `terraform.tfvars.json`. 

### auto.tfvars

This is used to automatically load bulk variables.
If you want Terraform to automatically load a `.tfvars` file with a custom name, you must give it the `.auto.tfvars` extension.

For example:
```bash
terraform apply -var-file="custom.auto.tfvars"
```

In this command, Terraform will automatically load the variable definitions from `custom.auto.tfvars`.

### order of terraform variables

Terraform variables are a way to define reusable, centrally controlled values. They can be defined in several ways, including in a separate variables file, within the Terraform configuration file itself, or through environment variables. The method you choose depends on your preference and the level of sensitivity of the variable values [k21academy.com](https://k21academy.com/terraform-iac/variables-in-terraform/).

The order of precedence for Terraform variables is as follows:
- Command-line flags (-var 'foo=bar'): Variables passed through the command line have the highest precedence. If a variable is defined both in a file and through the command line, the command line value will take precedence [env0.com](https://www.env0.com/blog/managing-terraform-variable-hierarchy).
- Environment variables (TF_VAR_name): Terraform will look for environment variables in the format `TF_VAR_name` as a fallback for defining variables. If both an environment variable and a file-defined variable exist, the environment variable takes precedence [developer.hashicorp.com](https://developer.hashicorp.com/terraform/language/values/variables).
- From file (terraform.tfvars or any .auto.tfvars): Terraform automatically loads any variables defined in files named `terraform.tfvars` or any file ending in `.auto.tfvars` in the current directory. These values are applied after considering variables from the command line and environment variables [medium.com](https://medium.com/@DevOps-Diva.o/understanding-terraform-variable-precedence-order-52a7c9d227e1).
Default value in the variable declaration: If no other value is set, Terraform will use the default value defined in the variable declaration [upcloud.com](https://upcloud.com/resources/tutorials/terraform-variables).

Here is an example of defining a variable in a .tfvars file:
```bash
variable "region" {
  type    = string
  default = "us-west-1"
}
```

This variable can be overridden by an environment variable:
```bash
export TF_VAR_region="us-east-1"
```

And finally, it can be overridden by a command-line flag:
```bash
terraform apply -var 'region=eu-west-1'
```

In this example, the final value of the region variable would be `eu-west-1` because the command-line flag takes precedence over the environment variable and the default value in the `.tfvars` file.

It's also possible to define complex types such as lists, maps, and objects for your variables. For example:
```bash
variable "instance_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t2.medium"]
}
```

This variable instance_types is a list of strings, with a default value of `["t2.micro", "t2.small", "t2.medium"]`. This variable could be used in your Terraform configuration to specify the instance types for an AWS Auto Scaling group, for instance [upcloud.com](https://upcloud.com/resources/tutorials/terraform-variables).


## Dealing With Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

```bash
terraform import aws_s3_bucket.bucket bucket-name
```

When working with modules: 
```bash
tf import module.terrahouse_aws.aws_s3_bucket.website_bucket tf-ohary-bucket-f360341c-994e-4bc0-bb9e-822df87902dc
tf import module.terrahouse_aws.aws_clEIFGY8E8B76Y2ribution.s3_distribution EIFGY8E8B76Y2
tf import module.terrahouse_aws.aws_cloudfront_origin_access_control.default E26TXKXYE54LJ9
```

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps. 

If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift


## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs (Large Language Modules) such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform


### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the Lifecycle of Resources

[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)


## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data


## Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec


## Heredoc

A HereDoc, short for Here Document, is a type of redirection in Bash and other Unix-like operating systems that allows you to create a block of text that can be used as input to a command, or as part of a script. It's a multiline string or a file literal for sending input streams to other commands and programs [phoenixnap.com](https://phoenixnap.com/kb/bash-heredoctf).

Basically, a heredoc is used for multiline commenting..

Here's a basic example of a HereDoc:
```bash
cat << EOF
Hello
World
EOF
```

In this example, `cat` is the command that reads the HereDoc and writes the contents to the terminal. The text between `EOF` markers is considered as the input to the `cat` command.

HereDocs are particularly useful when you need to use multiple commands or lines of text as input to another command. For example, you can use a HereDoc to provide input to a command, assign a block of text to a variable, create a file with a block of text, or append a block of text to a file.

Here's an example of using a HereDoc to assign a block of text to a variable:
```bash
variable=$(cat << crazy_file
Hello
World
crazy_file
)
```

In this example, the text between the `crazy_file` markers is assigned to the `variable`.

HereDocs can also be used with SSH to execute multiple commands on a remote machine. Here's an example:
```bash
ssh username@host << ssh_multiline
echo "Local user: $USER"
echo "Remote user: \$USER"
ssh_multiline
```

In this example, the `echo` commands are executed on the remote machine, and the output from the `echo` commands is printed to the console.

It's important to note that when using a HereDoc, you should be careful to escape any special characters or variables that you don't want to be interpreted by the shell. You can do this by adding a backslash (`\`) before the character, or by enclosing the HereDoc in single quotes (`'`).

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
