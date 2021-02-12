<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="icon" tagdir="/WEB-INF/tags/icons" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<spring:url var="URL_PREFIX" value="/web"/>

<style>
    #menu-toggle-checkbox ~ label ~ nav .navigation-items {
        overflow: hidden;
        transition: max-height 400ms ease-in;
    }
    #menu-toggle-checkbox:checked ~ label ~ nav .navigation-items {
        max-height: 90vh !important;
    }

    #menu-toggle-checkbox + label > span:first-child {
        width: 30px;
        height: 18px;
        position: relative;
    }

    #menu-toggle-checkbox + label > span > span {
        padding: 0;
        width: 30px;
        height: 4px;
        display: block;
        border-radius: 4px;
        transition: all 0.4s ease-in-out;
        position: absolute;
        background-color: #353535;
    }

    #menu-toggle-checkbox + label > span > span:nth-child(1) {
        top: 0;
        transition: all 0.4s ease-in-out, transform 0.4s ease-in-out 0.4s;
    }

    #menu-toggle-checkbox + label > span > span:nth-child(2) {
        top: 6.5px;
        width: 1px;
        transform: rotate(90deg);
        left: 6.5px;
    }

    #menu-toggle-checkbox + label > span > span:nth-child(3) {
        top: 6.5px;
        right: 0;
        width: 1px;
        left: 6.5px;
    }

    #menu-toggle-checkbox + label > span > span:nth-child(4) {
        bottom: 0;
        top: 6.5px;
    }

    #menu-toggle-checkbox + label > span > span:nth-child(5) {
        bottom: 0;
    }

    #menu-toggle-checkbox:checked + label > span > span:nth-child(1) {
        top: 6.5px;
        background-color: transparent;
    }

    #menu-toggle-checkbox:checked + label > span > span:nth-child(2) {
        left: 0;
        width: 30px;
        transform: rotate(45deg);
    }

    #menu-toggle-checkbox:checked + label > span > span:nth-child(3) {
        left: 0;
        width: 30px;
        transform: rotate(-45deg);
    }

    #menu-toggle-checkbox:checked + label > span > span:nth-child(4) {
        background-color: transparent !important;
    }

    #menu-toggle-checkbox:checked + label > span > span:nth-child(5) {
        bottom: 6.5px;
        background-color: transparent !important;
    }
</style>

<div class="navigation">
    <input id="menu-toggle-checkbox" type="checkbox" class="tw-hidden">
    <label for="menu-toggle-checkbox" class="tw-flex tw-items-center tw-px-4 tw-py-4 tw-absolute tw-top-0 tw-left-0 lg:tw-hidden tw-cursor-pointer">
        <span class="tw-inline-block">
            <span class="hamburger-bar"></span>
            <span class="hamburger-bar"></span>
            <span class="hamburger-bar"></span>
            <span class="hamburger-bar"></span>
            <span class="hamburger-bar"></span>
        </span>
    </label>
    <nav class="tw-max-w-6xl tw-mx-auto">
        <div class="tw-flex tw-w-full tw-bg-gray-100">
            <div class="tw-p-3 tw-order-last lg:tw-p-2 tw-flex tw-items-start lg:tw-items-center tw-relative">
                <a href="#avatar-menu" class="tw-inline-block" id="avatar-link" aria-expanded="false" aria-haspopup="true">
                    <img
                        src="<c:out value='${menuGravatarUrl}'/>"
                        alt=""
                        class="gravatar tw-rounded-full"
                        width="24px"
                        height="24px"
                        onerror="this.src !== '/images/gravatar.jpg' && (this.src = '/images/gravatar.jpg')"
                    />
                </a>
                <div
                    id="avatar-menu"
                    class="tw-w-screen tw-absolute tw-right-3 tw-top-full tw-flex tw-justify-end tw-transform tw-origin-top-right tw-transition-transform tw-scale-x-0 tw-scale-y-0 tw-scale-x-1 tw-scale-y-1 tw--translate-y-2"
                    aria-hidden="true"
                >
                    <div
                        class="tw-inline-block tw-px-6 tw-py-4 tw-bg-gray-600 tw-bg-opacity-80 tw-rounded-md"
                        style="backdrop-filter: blur(3px)"
                    >
                        <ul class="tw-list-none tw-m-0 tw-p-0 tw-space-y-4" role="menu">
                            <li class="tw-flex tw-items-center" role="none">
                                <form:form action="/logout" method="POST" cssClass="tw-ml-auto">
                                    <button
                                        role="menuitem"
                                        type="submit"
                                        class="tw-inline-block tw-text-lg lg:tw-text-base tw-bg-transparent tw-p-0 tw-text-right"
                                    >
                                        <span class="tw-flex tw-items-center tw-text-white">
                                            <icon:logout className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4" />
                                            <span class="tw-ml-4">
                                                <spring:message code="nav.signout.title"/>
                                            </span>
                                        </span>
                                    </button>
                                </form:form>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="tw-flex-1 navigation-items tw-mt-12 lg:tw-mt-0 tw-max-h-0 lg:tw-max-h-full">
                <ul class="tw-list-none tw-m-0 tw-py-3 tw-px-5 tw-flex tw-flex-col tw-space-y-4 lg:tw-flex-row lg:tw-space-y-0 lg:tw-space-x-8 lg:tw-px-2 xl:tw-px-0">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/overview" id="home-link" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:home className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2 lg:tw-sr-only xl:tw-not-sr-only xl:tw-ml-2">
                                    <spring:message code="nav.home.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    <sec:authorize access="hasAuthority('USER')">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/application/new" id="application-new-link" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:plus-circle className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.apply.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    </sec:authorize>
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/application" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:calendar className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.vacation.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    <sec:authorize access="hasAuthority('OFFICE')">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/sicknote" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:medkit className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.sicknote.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyAuthority('DEPARTMENT_HEAD', 'BOSS', 'OFFICE', 'SECOND_STAGE_AUTHORITY')">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/person?active=true" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:user className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.person.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyAuthority('BOSS', 'OFFICE')">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/department" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:user-group className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.department.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    </sec:authorize>
                    <sec:authorize access="hasAuthority('OFFICE')">
                    <li class="tw-flex tw-items-center">
                        <a href="${URL_PREFIX}/settings" class="tw-group tw-inline-block tw-no-underline tw-text-gray-900 tw-text-lg lg:tw-text-base hover:tw-text-blue-400 tw-transition-colors">
                            <span class="tw-flex tw-items-center">
                                <icon:cog className="tw-w-6 tw-h-6 lg:tw-w-4 lg:tw-h-4 tw-text-gray-900 tw-text-opacity-50 group-hover:tw-text-blue-400 tw-transition-colors" />
                                <span class="tw-ml-5 lg:tw-ml-2">
                                    <spring:message code="nav.settings.title"/>
                                </span>
                            </span>
                        </a>
                    </li>
                    </sec:authorize>
                </ul>
            </div>
        </div>
        <div class="tw-flex tw-w-full lg:tw-hidden">
            <div class="tw-w-4 tw-bg-gray-100">
                <div class="tw-h-4 tw-rounded-tl-full tw-bg-white"></div>
            </div>
            <div class="tw-flex-1"></div>
            <div class="tw-w-4 tw-bg-gray-100">
                <div class="tw-h-4 tw-rounded-tr-full tw-bg-white"></div>
            </div>
        </div>
    </nav>
</div>
