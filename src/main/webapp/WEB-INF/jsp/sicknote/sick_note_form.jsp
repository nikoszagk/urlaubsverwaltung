<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="icon" tagdir="/WEB-INF/tags/icons" %>
<%@taglib prefix="asset" uri="/WEB-INF/asset.tld" %>

<!DOCTYPE html>
<html lang="${language}">
<head>
    <title>
        <c:choose>
            <c:when test="${sickNote.id == null}">
                <spring:message code="sicknote.create.header.title"/>
            </c:when>
            <c:otherwise>
                <spring:message code="sicknote.edit.header.title"/>
            </c:otherwise>
        </c:choose>
    </title>
    <uv:custom-head/>
    <script>
        window.uv = {};
        window.uv.personId = '<c:out value="${person.id}" />';
        window.uv.webPrefix = "<spring:url value='/web' />";
        window.uv.apiPrefix = "<spring:url value='/api' />";
        window.uv.sickNote = {};
        window.uv.sickNote.id = "<c:out value="${sickNote.id}" />";
        window.uv.sickNote.person = {};
        window.uv.sickNote.person.id = "<c:out value="${sickNote.person.id}" />";
        window.uv.params = {};
        window.uv.params.person = "${param.person}";
    </script>
    <uv:datepicker-localisation/>
    <link rel="stylesheet" type="text/css" href="<asset:url value='account_form~app_form~app_statistics~overtime_form~sick_note_form~sick_notes~workingtime_form.css' />"/>
    <link rel="stylesheet" type="text/css" href="<asset:url value='account_form~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_notes~workingtime_form.css' />"/>
    <script defer src="<asset:url value='npm.duetds.js' />"></script>
    <script defer src="<asset:url value='npm.date-fns.js' />"></script>
    <script defer src="<asset:url value='account_form~app_form~app_statistics~overtime_form~sick_note_form~sick_notes~workingtime_form.js' />"></script>
    <script defer src="<asset:url value='account_form~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_notes~workingtime_form.js' />"></script>
    <script defer src="<asset:url value='account_form~app_detail~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_no~95889e93.js' />"></script>
    <script defer src="<asset:url value='sick_note_form.js' />"></script>
</head>
<body>

<spring:url var="URL_PREFIX" value="/web"/>

<uv:menu/>

<c:set var="DATE_PATTERN">
    <spring:message code="pattern.date"/>
</c:set>

<div class="content">
    <div class="container">

        <c:choose>
            <c:when test="${sickNote.id == null}">
                <c:set var="ACTION" value="${URL_PREFIX}/sicknote"/>
            </c:when>
            <c:otherwise>
                <c:set var="ACTION" value="${URL_PREFIX}/sicknote/${sickNote.id}/edit"/>
            </c:otherwise>
        </c:choose>

        <form:form method="POST" action="${ACTION}" modelAttribute="sickNote" class="form-horizontal">

            <c:if test="${not empty errors.globalErrors}">
                <div class="row">
                    <div class="col-xs-12 alert alert-danger">
                        <form:errors/>
                    </div>
                </div>
            </c:if>

            <div class="form-section tw-mb-4 lg:tw-mb-6">
                <uv:section-heading>
                    <h1>
                        <c:choose>
                            <c:when test="${sickNote.id == null}">
                                <spring:message code="sicknote.create.title"/>
                            </c:when>
                            <c:otherwise>
                                <spring:message code="sicknote.edit.title"/>
                            </c:otherwise>
                        </c:choose>
                    </h1>
                </uv:section-heading>
                <div class="row">
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block help-block tw-text-sm">
                            <icon:information-circle className="tw-w-4 tw-h-4" solid="true"/>
                            <spring:message code="sicknote.data.description"/>
                        </span>
                    </div>

                    <div class="col-md-8 col-md-pull-4">
                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="employee">
                                <spring:message code='sicknote.data.person'/>:
                            </label>

                            <div class="col-md-9">
                                <c:choose>
                                    <c:when test="${sickNote.id == null}">
                                        <uv:select id="employee" name="person" testId="person-select">
                                            <c:forEach items="${persons}" var="person">
                                                <option value="${person.id}" ${sickNote.person.id == person.id ? 'selected="selected"' : ''}>
                                                    ${person.niceName}
                                                </option>
                                            </c:forEach>
                                        </uv:select>
                                    </c:when>
                                    <c:otherwise>
                                        <form:hidden path="id"/>
                                        <form:hidden path="person" value="${sickNote.person.id}"/>
                                        <c:out value="${sickNote.person.niceName}"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="sickNoteType">
                                <spring:message code="sicknote.data.type"/>:
                            </label>

                            <div class="col-md-9">
                                <uv:select id="sickNoteType" name="sickNoteType" testId="sicknote-type-select">
                                    <c:forEach items="${sickNoteTypes}" var="sickNoteType">
                                        <option value="${sickNoteType.id}" ${sickNoteType == sickNote.sickNoteType ? 'selected="selected"' : ''}>
                                            <spring:message code="${sickNoteType.messageKey}"/>
                                        </option>
                                    </c:forEach>
                                </uv:select>
                            </div>
                        </div>

                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="dayLength">
                                <spring:message code="absence.period"/>:
                            </label>
                            <div class="col-md-9">
                                <div class="radio">
                                    <label class="thirds">
                                        <form:radiobutton path="dayLength" value="FULL" checked="checked" data-test-id="day-type-full" />
                                        <spring:message code="FULL"/>
                                    </label>
                                    <label class="thirds">
                                        <form:radiobutton path="dayLength" value="MORNING" data-test-id="day-type-morning" />
                                        <spring:message code="MORNING"/>
                                    </label>
                                    <label class="thirds">
                                        <form:radiobutton path="dayLength" value="NOON" data-test-id="day-type-noon" />
                                        <spring:message code="NOON"/>
                                    </label>
                                </div>
                                <uv:error-text>
                                    <form:errors path="dayLength" />
                                </uv:error-text>
                            </div>
                        </div>

                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="from">
                                <spring:message code="absence.period.startDate"/>:
                            </label>
                            <div class="col-md-9">
                                <form:input id="from" path="startDate" data-iso-value="${sickNote.startDateIsoValue}"
                                            class="form-control" cssErrorClass="form-control error" autocomplete="off"
                                            placeholder="${DATE_PATTERN}" data-test-id="sicknote-from-date" />
                                <uv:error-text>
                                    <form:errors path="startDate" />
                                </uv:error-text>
                            </div>
                        </div>

                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="to">
                                <spring:message code="absence.period.endDate"/>:
                            </label>
                            <div class="col-md-9">
                                <form:input id="to" path="endDate" data-iso-value="${sickNote.endDateIsoValue}"
                                            class="form-control" cssErrorClass="form-control error" autocomplete="off"
                                            placeholder="${DATE_PATTERN}" data-test-id="sicknote-to-date" />
                                <uv:error-text>
                                    <form:errors path="endDate" />
                                </uv:error-text>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-section tw-mb-4 lg:tw-mb-6">
                <uv:section-heading>
                    <h2>
                        <spring:message code="sicknote.data.aub.short"/>
                    </h2>
                </uv:section-heading>
                <div class="row">
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block help-block tw-text-sm">
                            <icon:information-circle className="tw-w-4 tw-h-4" solid="true"/>
                            <spring:message code="sicknote.data.person"/>
                        </span>
                    </div>
                    <div class="col-md-8 col-md-pull-4">
                        <div class="form-group AU">
                            <label class="control-label col-md-3" for="aubFrom">
                                <spring:message code="absence.period.startDate"/>:
                            </label>

                            <div class="col-md-9">
                                <form:input id="aubFrom" path="aubStartDate" class="form-control"
                                            cssErrorClass="form-control error" autocomplete="off"
                                            placeholder="${DATE_PATTERN}" data-test-id="sicknote-aub-from"/>
                                <uv:error-text>
                                    <form:errors path="aubStartDate" />
                                </uv:error-text>
                            </div>
                        </div>
                        <div class="form-group AU">
                            <label class="control-label col-md-3" for="aubTo">
                                <spring:message code="absence.period.endDate"/>
                            </label>

                            <div class="col-md-9">
                                <form:input id="aubTo" path="aubEndDate" class="form-control"
                                            cssErrorClass="form-control error" autocomplete="off"
                                            placeholder="${DATE_PATTERN}" data-test-id="sicknote-aub-to" />
                                <uv:error-text>
                                    <form:errors path="aubEndDate" />
                                </uv:error-text>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-section tw-mb-16">
                <uv:section-heading>
                    <h2>
                        <spring:message code="sicknote.data.furtherInformation.title"/>
                    </h2>
                </uv:section-heading>
                <div class="row">
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block help-block tw-text-sm">
                            <icon:information-circle className="tw-w-4 tw-h-4" solid="true"/>
                            <spring:message code="sicknote.data.furtherInformation.description"/>
                        </span>
                    </div>
                    <div class="col-md-8 col-md-pull-4">
                        <div class="form-group">
                            <label class="control-label col-md-3" for="comment">
                                <spring:message code="sicknote.data.furtherInformation.comment"/>:
                            </label>
                            <div class="col-md-9">
                                <small>
                                    <span id="text-comment"></span><spring:message code="action.comment.maxChars"/>
                                </small>
                                <form:textarea id="comment" rows="1" path="comment" class="form-control"
                                               cssErrorClass="form-control error"
                                               onkeyup="count(this.value, 'text-comment');"
                                               onkeydown="maxChars(this,200); count(this.value, 'text-comment');"/>
                                <uv:error-text>
                                    <form:errors path="comment" />
                                </uv:error-text>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="row">
                    <div class="col-xs-12">
                        <hr/>
                        <button
                            class="btn btn-success col-xs-12 col-sm-5 col-md-2"
                            type="submit"
                            data-test-id="sicknote-submit-button"
                        >
                            <spring:message code="action.save"/>
                        </button>
                        <button class="btn btn-default back col-xs-12 col-sm-5 col-md-2 pull-right" type="button">
                            <spring:message code="action.cancel"/>
                        </button>
                    </div>
                </div>
            </div>

        </form:form>

    </div>
</div>

</body>
</html>
