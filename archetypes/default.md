+++
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
date = {{ .Date }}
draft = true
author = '{{ .Site.Params.author }}'
author_image = '{{ .Site.Params.author_image }}'
+++
