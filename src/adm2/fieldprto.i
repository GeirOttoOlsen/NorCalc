/*
 * Prototype include file: C:\adm91a\src\adm2\fieldprto.i
 * Created from procedure: C:\adm91a\src\adm2\field.p at 13:04 on 06/24/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

FUNCTION getDataModified RETURNS LOGICAL IN SUPER.

FUNCTION getDisplayField RETURNS LOGICAL IN SUPER.

FUNCTION getEnableField RETURNS LOGICAL IN SUPER.

FUNCTION getFieldEnabled RETURNS LOGICAL IN SUPER.

FUNCTION getFieldName RETURNS CHARACTER IN SUPER.

FUNCTION setDataModified RETURNS LOGICAL
  (INPUT plModified AS LOGICAL) IN SUPER.

FUNCTION setDisplayField RETURNS LOGICAL
  (INPUT plDisplay AS LOGICAL) IN SUPER.

FUNCTION setEnableField RETURNS LOGICAL
  (INPUT plEnable AS LOGICAL) IN SUPER.

FUNCTION setFieldEnabled RETURNS LOGICAL
  (INPUT plEnabled AS LOGICAL) IN SUPER.

FUNCTION setFieldName RETURNS LOGICAL
  (INPUT pcField AS CHARACTER) IN SUPER.

