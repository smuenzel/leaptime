(lang dune 3.18)
(using cinaps 1.3)

(name leaptime)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name leaptime)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml ppx_jane core_kernel)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
