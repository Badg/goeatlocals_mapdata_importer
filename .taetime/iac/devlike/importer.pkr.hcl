# TODO: wire up "tae devops packer" so that it automatically populates these
# instead of defining them here as defaults
variable "project_name" {
    type = string
    description = "The name of the project, as used by taetime"
    default = "goeatlocals_mapdata_importer"
}

variable "image_name" {
    type = string
    description = "The name of the image within the project"
    default = "importer"
}

variable "aws_acct_id" {
    type = string
    description = "The AWS account ID for the control plane"
}

variable "base_image_date" {
    type = string
    description = "The date tag to use for the base image."
    default = "2020-06-26"
}


source "docker" "bionic" {
    image = "${var.aws_acct_id}.dkr.ecr.us-west-2.amazonaws.com/taetime_dev/base_ubuntu_bionic:${var.base_image_date}"
    commit = true
    ecr_login = true
    aws_profile = "taev_root_devops"
    login_server = "https://${var.aws_acct_id}.dkr.ecr.us-west-2.amazonaws.com/"
}

build {
    sources = [
        "source.docker.bionic"
    ]

    provisioner "shell" {
        inline = [
            # Our base image is old; TODO: update base image
            "apt-get update",
            # We need gpg before apt-key add
            "apt-get install -y lsb-release ca-certificates gnupg checkinstall",
            "curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -",
            "sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main\" > /etc/apt/sources.list.d/pgdg.list'",
            "apt-get update",
            "apt-get install -y postgresql-client-12",
            "apt-get install -y libcharls-dev libgdal-dev",
            "apt-get install -y graphviz sqlite3 aria2 osmctools python3.8 python3.8-venv python3.8-dev zlib1g-dev libosmium-dev cmake",
            # We need libgdal-dev but we need to get rid of the old versions of these
            "apt-get remove -y libproj-dev libproj12 proj-bin proj-data",

            "curl -OL https://download.osgeo.org/proj/proj-6.3.2.tar.gz",
            "tar -xvzf proj-6.3.2.tar.gz",
            "cd proj-6.3.2",
            "./configure --prefix=/usr",
            "make",
            "DEBIAN_FRONTEND=noninteractive checkinstall -y",
            "cd ../",
            "curl -OL https://github.com/OSGeo/gdal/releases/download/v3.1.0/gdal-3.1.0.tar.gz",
            "tar -xvzf gdal-3.1.0.tar.gz",
            "cd gdal-3.1.0",
            "./configure --prefix=/usr",
            "make",
            "DEBIAN_FRONTEND=noninteractive checkinstall -y",
            "cd ../",

            "curl -OL https://github.com/omniscale/imposm3/releases/download/v0.10.0/imposm-0.10.0-linux-x86-64.tar.gz",
            "tar -xzf imposm-0.10.0-linux-x86-64.tar.gz",
            # Moving because of issue with running executables from user home dir
            # TODO: need more sensible location!
            "mv ./imposm-0.10.0-linux-x86-64 /imposm",
            "ln -s /imposm/imposm3 /usr/bin/imposm",

            "git clone https://github.com/pnorman/osmborder.git",
            "cd osmborder",
            "cmake .",
            "DEBIAN_FRONTEND=noninteractive make install"
        ]
    }

    # ------------------------------------------------------------------------
    # Don't touch these for normal use! This will automatically adhere to our
    # naming conventions based on the variables.
    post-processor "docker-tag" {
        repository = "${var.aws_acct_id}.dkr.ecr.us-west-2.amazonaws.com/${var.project_name}/${var.image_name}"
        tag = [formatdate("YYYY-MM-DD", timestamp())]
    }

    post-processor "docker-push" {
        ecr_login = true
        aws_profile = "taev_root_devops"
        login_server = "https://${var.aws_acct_id}.dkr.ecr.us-west-2.amazonaws.com/"
    }
}
