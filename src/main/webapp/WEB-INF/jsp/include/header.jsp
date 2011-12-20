<%-- 
    Document   : header
    Created on : 19.10.2011, 15:21:35
    Author     : Aljona Murygina
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

       

        <spring:url var="formUrlPrefix" value="/web" />
        
        <div id="top-menu">
            <spring:message code="loggedas" />&nbsp;<sec:authentication property="principal.username" />  
            <a class="button" href="<spring:url value='/j_spring_security_logout' />">Logout</a>
        </div>
        
        <div id="header">
            
            <h1><spring:message code="header.title" /></h1>

            <div id="main-menu">
                
                <ul><li><a href="${formUrlPrefix}/staff/${loggedUser.id}/overview"><spring:message code="overview" /></a></li>
                    <li><a href="${formUrlPrefix}/${loggedUser.id}/application/new"><spring:message code="apply" /></a></li>
                    <li><a href="${formUrlPrefix}/application/waiting"><spring:message code="waiting.app" /></a></li>
                    <li><a href="${formUrlPrefix}/application/allowed"><spring:message code="allow.app" /></a></li>
                    <li><a href="${formUrlPrefix}/application/cancelled"><spring:message code="cancel.app" /></a></li>
                    <li><a href="${formUrlPrefix}/staff/list"><spring:message code="overview" />&nbsp;<spring:message code="staff" /></a></li>
                    <li><a href="${formUrlPrefix}/manager"><spring:message code="office" /></a></li>
                </ul>
                
                    <%--
                <sec:authorize access="hasRole('role.user')">
                <ul>
                    <li><a href="${formUrlPrefix}/staff/${loggedUser.id}/overview"><spring:message code="overview" /></a></li>
                    <li><a href="${formUrlPrefix}/application/${loggedUser.id}/new"><spring:message code="apply" /></a></li>
                </ul>
                </sec:authorize>
            
                <sec:authorize access="hasRole('role.chef')">
                <ul><li><a href="${formUrlPrefix}/staff/${loggedUser.id}/overview"><spring:message code="overview" /></a></li>
                    <li><a href="${formUrlPrefix}/application/${loggedUser.id}/new"><spring:message code="apply" /></a></li>
                    <li><a href="${formUrlPrefix}/application/waiting"><spring:message code="waiting.app" /></a></li>
                    <li><a href="${formUrlPrefix}/application/allowed"><spring:message code="allow.app" /></a></li>
                    <li><a href="${formUrlPrefix}/application/cancelled"><spring:message code="cancel.app" /></a></li>
                    <li><a href="${formUrlPrefix}/staff/list"><spring:message code="overview" />&nbsp;<spring:message code="staff" /></a></li>
                </ul>
                </sec:authorize>
            
                <sec:authorize access="hasRole('role.office')">
                <ul><li><a href="${formUrlPrefix}/staff/${loggedUser.id}/overview"><spring:message code="overview" /></a></li>
                    <li><a href="${formUrlPrefix}/application/${loggedUser.id}/new"><spring:message code="apply" /></a></li>
                    <li><a href="${formUrlPrefix}/application/allowed"><spring:message code="allow.app" /></a></li>
                    <li><a href="${formUrlPrefix}/application/cancelled"><spring:message code="cancel.app" /></a></li>
                    <li><a href="${formUrlPrefix}/staff/list"><spring:message code="overview" />&nbsp;<spring:message code="staff" /></a></li>
                    <li><a href="${formUrlPrefix}/manager"><spring:message code="office" /></a></li>
                </ul>
                </sec:authorize>
                    --%>
                
            </div>

        </div>

        
        
