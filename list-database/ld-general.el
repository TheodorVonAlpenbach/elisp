(defun ld-warning (format-string &rest args)
  (format "Warning: %s" (apply #'message format-string args)))
;;(ld-warning "qwe%d" 1)

(defun ld-type (ldobj)
  (cond ((ld-identifier-p ldobj) 'identifier)
	((ld-database-p ldobj) 'database)
	((ld-table-p ldobj) 'table)
	((ld-schema-p ldobj) 'schema)
	((ld-column-p ldobj) 'column)
	(t (error "ldobj is not an ld entity! %S" ldobj))))
;;(ld-autogenerate-p (first (ld-table-column-definitions (ld-table :users))))

(defun ld-identifier (ldobj)
  (ecase (ld-type ldobj)
    (identifier ldobj)
    (database (ld-database-identifier ldobj))
    (table (ld-table-identifier ldobj))
    (schema (ld-schema-identifier ldobj))
    (column (ld-column-identifier ldobj))))
;;(mapcar #'ld-identifier (list *current-DB* emps comps))

(defun ld-keyword (ldobj)
  (when ldobj
    (if (keywordp ldobj)
      ldobj
      (ld-identifier-keyword (ld-identifier ldobj)))))
;;(mapcar #'ld-keyword (list '(nil) *current-DB* emps comps))

(defun ld-database-id (ldobj)
  (ecase (ld-type ldobj)
    (identifier ())
    (database ldobj)
    ((schema table) (ld-parent ldobj))
    (column (ld-database (ld-parent ldobj)))))

(defun ld-database (ldobj)
  (ecase (ld-type ldobj)
    (database ldobj)
    ((schema table) (ld-parent ldobj))
    (column (ld-database (ld-parent ldobj)))))

(defun ld-parent-id (ldobj)
  (ecase (ld-type ldobj)
    (identifier (butlast ldobj))
    (t (ld-parent-id (ld-identifier ldobj)))))
;;(ld-table-repository emps)

(defun ld-parent (ldobj)
  (awhen (ld-parent-id ldobj)
    (ld-object it)))

(defun ld-object (id)
  (when (listp id)
    (case (length id)
      (0 nil)
      (1 (and (first id) (ld-database id)))
      (2 (ld-table id))
      (3 (find id (ld-table-column-definitions (ld-object (ld-parent-id id)))
	       :key #'ld-column-identifier)))))

(provide 'ld-general)
