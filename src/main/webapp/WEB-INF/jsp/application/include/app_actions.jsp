<%-- 
    Document   : app_actions
    Created on : 30.01.2012, 16:31:03
    Author     : Aljona Murygina
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>



                    <%-- if user wants to cancel an application --%>
                    <c:if test="${stateNumber == 4}">
                        <form:form method="put" action="${formUrlPrefix}/application/${application.id}/cancel">
                            <spring:message code='cancel.confirm' /> <br /><br />
                            <input type="submit" class="button confirm" name="<spring:message code='delete' />" value="<spring:message code='delete' />" />
                            <a class="button back" href="${formUrlPrefix}/overview"><spring:message code='cancel' /></a>
                        </form:form>
                    </c:if>

                    <%-- application is waiting --%>            
                    <c:if test="${stateNumber == 0}">

                        <sec:authorize access="hasRole('role.boss')">         

                            <form:form method="put" action="${formUrlPrefix}/application/${application.id}/allow"> 
                                <input class="confirm" type="submit" name="<spring:message code='app.state.ok' />" value="<spring:message code='app.state.ok' />" class="button" />    
                                <input class="back" type="button" name="<spring:message code='app.state.no' />" value="<spring:message code='app.state.no' />" onclick="$('#reject').show();" />
                            </form:form>   
                                <form:form method="put" action="${formUrlPrefix}/application/${application.id}/reject" modelAttribute="comment">
                                 <br />
                            <div id="reject" style="
                                     <c:choose>
                                         <c:when test="${not empty errors}">display: block</c:when>
                                         <c:otherwise>display: none</c:otherwise>
                                     </c:choose>
                                ">            
                                    <spring:message code='reason' />:&nbsp;&nbsp;<form:input path="text" cssErrorClass="error" />   
                                    <input type="submit" name="<spring:message code='ok' />" value="<spring:message code='ok' />" class="button" />
                                    <script type="text/javascript">
                                    $(document).ready(function() {
                                        $('#reject-error').show('drop', 500);
                                    });
                                </script>
                                    <form:errors path="text" cssClass="error" id="reject-error" />
                                </div>
                                </form:form>  

                        </sec:authorize>

                    </c:if>

                    <%-- application is allowed or cancelled: just print --%>  
                    <c:if test="${stateNumber == 1 || stateNumber == 2}">
                        
                        <a class="button print" href="${formUrlPrefix}/application/${application.id}/print"><spring:message code='app' />&nbsp;<spring:message code='print' /></a>

                    </c:if>

