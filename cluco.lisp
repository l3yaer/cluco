;;;; cluco.lisp

(in-package #:cluco)

(defun escape-html (text)
  (let ((replacements '(("&" . "&amp;")
						("<" . "&lt;")
						(">" . "&gt;")
						("\"" . "&quot;")
						("'" . "&apos;"))))
	(reduce (lambda (old arg)
			  (cl-ppcre:regex-replace-all (car arg) old (cdr arg)))
			replacements
			:initial-value text)))

(defun format-attr (name value)
  (format nil " ~a=\"~a\"" (string-downcase name) (string-downcase (escape-html value))))

(defun make-attrs (attrs)
  (format nil "~{~a~}"
   (sort
	 (loop for (name value) on attrs by #'cddr
		   collect (cond ((eq value t) (format-attr name name))
						 ((not value) (string ""))
						 (t (format-attr name value))))
	 #'string-lessp)))

(defparameter *re-tag* "([^\s\.#]+)(?:#([^\s\.#]+))?(?:\.([^\s#]+))?")

(defparameter *container-tags* '("a" "b" "body" "dd" "div" "dl" "dt"
								 "em" "fieldset" "form" "h1" "h2"
								 "h3" "h4" "h5" "h6" "head" "html"
								 "i" "label" "li" "ol" "pre"
								 "script" "span" "strong" "style"
								 "textarea" "ul"))

(defun parse-tag-name (tag)
  (cl-ppcre:register-groups-bind (tag-name id class)
	  (*re-tag*(string tag))
	(list tag-name id class)))

(defun render-tag (data)
  (let* ((tag (first data))
		 (content (rest data))
		 (attr (parse-tag-name tag))
		 (tag-name (string-downcase (first attr)))
		 (id (second attr))
		 (class (third attr))
		 (tag-attrs (list
					 :id id
					 :class (when class
							   (cl-ppcre:regex-replace-all "\\." class " "))))
		 (map-attrs (first content))
		 (attrs-content (if (listp map-attrs)
					(list (concatenate 'list tag-attrs map-attrs) (rest content))
					(list tag-attrs content)))
		 (attrs (first attrs-content))
		 (content (second attrs-content)))
	(if (or content (find tag-name *container-tags* :test #'equal))
		(format nil "<~a~a> ~a </~a>" tag-name (make-attrs attrs) (render-html content) tag-name)
		(format nil "<~a~a/>" tag-name (make-attrs attrs)))))

(defun render-html (data)
  (cond
	((stringp data) data)
	((vectorp data) (render-tag (coerce data 'list)))
	((listp data) (format nil "~{~a~}" (mapcar #'render-html data)))
	((not data) (string ""))
	(t (format nil "~a" data))))

(defun html (&rest content)
  (render-html content))
