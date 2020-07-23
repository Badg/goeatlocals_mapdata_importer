locals {
    # TODO: oops, this doesn't scale lol
    importer_container_name = "importer"
}

variable "importer_base_image_date" {
    type = string
    description = "The date tag to use for the importer base image."
    default = "2020-07-20"
}

resource "docker_container" "goeatlocals_mapdata_importer-importer" {
    image = docker_image.goeatlocals_mapdata_importer-importer.latest
    name  = "${var.project_name}-${local.importer_container_name}"

    networks_advanced { name = local.container_network }
    volumes {
        container_path = "/taetime_dev"
        host_path = "${var.host_workdir}/taetime_dev"
    }
    volumes {
        container_path = "/project_src"
        host_path = "${var.host_workdir}/${var.project_name}"
    }
    volumes {
        container_path = "/project_data"
        volume_name = local.project_data_volume
    }

    env = [
        "LC_ALL=C.UTF-8",
        # I don't want to explicitly specify this, but it works as a workaround
        # for a terraform docker provider bug that was resulting in always
        # forcing replacement of resources
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    ]

    # entrypoint = [ "/bin/bash", "/project_src/.taetime/iac/devlike/importer_shim.sh" ]

    entrypoint = [ "sleep" ]
    command = [ "infinity" ]

    ports {
        internal = 6767
    }
}

data "docker_registry_image" "goeatlocals_mapdata_importer-importer" {
    name = "${local.aws_control_acct_id}.dkr.ecr.us-west-2.amazonaws.com/goeatlocals_mapdata_importer/importer:${var.importer_base_image_date}"
}

resource "docker_image" "goeatlocals_mapdata_importer-importer" {
    name          = data.docker_registry_image.goeatlocals_mapdata_importer-importer.name
    pull_triggers = [data.docker_registry_image.goeatlocals_mapdata_importer-importer.sha256_digest]
}
