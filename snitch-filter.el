;;; snitch-filter.el -- part of snitch     -*- lexical-binding: t; -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; See snitch.el for full details.
;;
;; Copyright (C) 2020 Trevor Bentley
;; Author: Trevor Bentley <snitch.el@x.mrmekon.com>
;; URL: https://github.com/mrmekon/snitch-el
;;
;; This file is not part of GNU Emacs.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; This file provides some filter functions for snitch.el.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;;
;;
;; Filter functions
;;
;;

(defun snitch-filter-name (event name)
  "Filter function for snitch rules.

Takes the event object EVENT and process name as a string in
NAME.  Applies to both network and subprocess events."
  (string-equal (oref event proc-name) name))

(defun snitch-filter-src-pkg (event pkg)
  "Filter function for snitch rules.

Takes the event object EVENT, and Emacs package that originated
the event, PKG, as a symbol.  Applies to both network and
subprocess events."
  (eq (oref event src-pkg) pkg))

(defun snitch-filter-log (event &rest alist)
  "Filter function for snitch rules.

Takes the event object EVENT, and ALIST, an alist generated by
the snitch log filter wizard, filtering on all specified fields."
  (cl-loop for (aslot . avalue) in alist
           with accept = t
           do
           (let ((evalue (eieio-oref event aslot))
                 (val-type (type-of avalue)))
             (unless (cond
                      ((eq val-type 'string) (string-equal avalue evalue))
                      (t (eq avalue evalue)))
               (setq accept nil)))
           ;; short-circuit, stop checking after first failure
           when (null accept)
           return nil
           finally return accept))

(provide 'snitch-filter)

;;; snitch-filter.el ends here
