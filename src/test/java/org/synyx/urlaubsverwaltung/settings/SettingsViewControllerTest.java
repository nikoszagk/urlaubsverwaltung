package org.synyx.urlaubsverwaltung.settings;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.validation.Errors;
import org.synyx.urlaubsverwaltung.absence.Absence;
import org.synyx.urlaubsverwaltung.absence.TimeSettings;
import org.synyx.urlaubsverwaltung.account.AccountProperties;
import org.synyx.urlaubsverwaltung.account.AccountSettings;
import org.synyx.urlaubsverwaltung.application.settings.ApplicationSettings;
import org.synyx.urlaubsverwaltung.application.specialleave.SpecialLeaveSettingsService;
import org.synyx.urlaubsverwaltung.application.vacationtype.VacationCategory;
import org.synyx.urlaubsverwaltung.application.vacationtype.VacationType;
import org.synyx.urlaubsverwaltung.application.vacationtype.VacationTypeService;
import org.synyx.urlaubsverwaltung.calendarintegration.CalendarSettings;
import org.synyx.urlaubsverwaltung.calendarintegration.providers.CalendarProvider;
import org.synyx.urlaubsverwaltung.overtime.OvertimeSettings;
import org.synyx.urlaubsverwaltung.period.DayLength;
import org.synyx.urlaubsverwaltung.sicknote.settings.SickNoteSettings;
import org.synyx.urlaubsverwaltung.workingtime.FederalState;
import org.synyx.urlaubsverwaltung.workingtime.WorkingTimeProperties;
import org.synyx.urlaubsverwaltung.workingtime.WorkingTimeSettings;

import java.time.Clock;
import java.time.DayOfWeek;
import java.util.List;
import java.util.Optional;
import java.util.TimeZone;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.collection.IsIterableContainingInAnyOrder.containsInAnyOrder;
import static org.hamcrest.collection.IsIterableContainingInOrder.contains;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@ExtendWith(MockitoExtension.class)
class SettingsViewControllerTest {

    private SettingsViewController sut;

    private static final String OATUH_REDIRECT_REL = "/google-api-handshake";
    private static final String ERRORS_ATTRIBUTE = "errors";
    private static final String OAUTH_ERROR_ATTRIBUTE = "oautherrors";
    private static final String OAUTH_ERROR_VALUE = "some-error";

    private static final CalendarProvider SOME_CALENDAR_PROVIDER = new SomeCalendarProvider();
    private static final CalendarProvider ANOTHER_CALENDAR_PROVIDER = new AnotherCalendarProvider();
    private static final List<CalendarProvider> CALENDAR_PROVIDER_LIST = List.of(SOME_CALENDAR_PROVIDER, ANOTHER_CALENDAR_PROVIDER);

    private static final String SOME_GOOGLE_REFRESH_TOKEN = "0815-4711-242";

    @Mock
    private SettingsService settingsService;
    @Mock
    private VacationTypeService vacationTypeService;
    @Mock
    private SettingsValidator settingsValidator;
    @Mock
    private SpecialLeaveSettingsService specialLeaveService;

    private final Clock clock = Clock.systemUTC();

    @BeforeEach
    void setUp() {
        sut = new SettingsViewController(new AccountProperties(), new WorkingTimeProperties(), settingsService, vacationTypeService, CALENDAR_PROVIDER_LIST, settingsValidator, clock, "version", specialLeaveService);
    }

    @Test
    void getAuthorizedRedirectUrl() {
        final String actual = sut.getAuthorizedRedirectUrl("http://localhost:8080/web/settings", OATUH_REDIRECT_REL);
        final String expected = "http://localhost:8080/web" + OATUH_REDIRECT_REL;
        assertThat(actual).isEqualTo(expected);
    }

    @Test
    void ensureSettingsDetailsFillsModelCorrectly() throws Exception {

        final VacationType vacationType = new VacationType();
        vacationType.setId(1);
        vacationType.setActive(true);
        vacationType.setRequiresApproval(true);
        vacationType.setCategory(VacationCategory.HOLIDAY);
        vacationType.setMessageKey("vacationType.messageKey");
        when(vacationTypeService.getAllVacationTypes()).thenReturn(List.of(vacationType));

        final Settings settings = someSettings();
        when(settingsService.getSettings()).thenReturn(settings);

        final String requestUrl = "/web/settings";

        // TODO test explicit settings attributes
        perform(get(requestUrl))
            .andExpect(model().attributeExists("settings"))
            .andExpect(model().attribute("federalStateTypes", FederalState.federalStatesTypesByCountry()))
            .andExpect(model().attribute("dayLengthTypes", DayLength.values()))
            .andExpect(model().attribute("weekDays", DayOfWeek.values()))
            .andExpect(model().attribute("providers", contains("SomeCalendarProvider", "AnotherCalendarProvider")))
            .andExpect(model().attribute("availableTimezones", containsInAnyOrder(TimeZone.getAvailableIDs())))
            .andExpect(model().attribute("defaultVacationDaysFromSettings", is(false)))
            .andExpect(model().attribute("defaultWorkingTimeFromSettings", is(false)))
            .andExpect(model().attribute("authorizedRedirectUrl",
                sut.getAuthorizedRedirectUrl("http://localhost" + requestUrl, OATUH_REDIRECT_REL)));
    }

    @Test
    void ensureSettingsDetailsAddsOAuthErrorToModelIfErrorProvidedAndNoCurrentRefreshToken() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettingsWithoutGoogleCalendarRefreshToken());

        perform(get("/web/settings")
            .param(OAUTH_ERROR_ATTRIBUTE, OAUTH_ERROR_VALUE))
            .andExpect(model().attribute(OAUTH_ERROR_ATTRIBUTE, OAUTH_ERROR_VALUE))
            .andExpect(model().attribute(ERRORS_ATTRIBUTE, OAUTH_ERROR_VALUE));
    }

    @Test
    void ensureSettingsDetailsDoesNotAddOAuthErrorToModelIfErrorProvidedAndCurrentRefreshToken() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettingsWithGoogleCalendarRefreshToken());

        perform(get("/web/settings")
            .param(OAUTH_ERROR_ATTRIBUTE, OAUTH_ERROR_VALUE))
            .andExpect(model().attribute(OAUTH_ERROR_ATTRIBUTE, nullValue()))
            .andExpect(model().attribute(ERRORS_ATTRIBUTE, nullValue()));
    }

    @Test
    void ensureSettingsDetailsDoesNotAddOAuthErrorToModelIfNoErrorProvidedAndNoCurrentRefreshToken() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettingsWithoutGoogleCalendarRefreshToken());

        perform(get("/web/settings"))
            .andExpect(model().attribute(OAUTH_ERROR_ATTRIBUTE, nullValue()))
            .andExpect(model().attribute(ERRORS_ATTRIBUTE, nullValue()));
    }

    @Test
    void ensureSettingsDetailsDoesNotAddOAuthErrorToModelIfNoErrorProvidedAndCurrentRefreshToken() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettingsWithGoogleCalendarRefreshToken());

        perform(get("/web/settings"))
            .andExpect(model().attribute(OAUTH_ERROR_ATTRIBUTE, nullValue()))
            .andExpect(model().attribute(ERRORS_ATTRIBUTE, nullValue()));
    }

    @Test
    void ensureSettingsDetailsSetsDefaultExchangeTimeZoneIfNoneConfigured() throws Exception {

        final Settings settings = someSettingsWithNoExchangeTimezone();
        when(settingsService.getSettings()).thenReturn(settings);

        assertThat(settings.getCalendarSettings().getExchangeCalendarSettings().getTimeZoneId()).isNull();

        perform(get("/web/settings"));

        assertThat(settings.getCalendarSettings().getExchangeCalendarSettings().getTimeZoneId())
            .isEqualTo(clock.getZone().getId());
    }

    @Test
    void ensureSettingsDetailsDoesNotAlterExchangeTimeZoneIfAlreadyConfigured() throws Exception {

        final String timeZoneId = "XYZ";
        final Settings settings = someSettingsWithExchangeTimeZone(timeZoneId);
        when(settingsService.getSettings()).thenReturn(someSettingsWithExchangeTimeZone(timeZoneId));

        assertThat(settings.getCalendarSettings().getExchangeCalendarSettings().getTimeZoneId()).isEqualTo(timeZoneId);

        perform(get("/web/settings"));

        assertThat(settings.getCalendarSettings().getExchangeCalendarSettings().getTimeZoneId()).isEqualTo(timeZoneId);
    }

    @Test
    void ensureSettingsDetailsUsesCorrectView() throws Exception {
        when(settingsService.getSettings()).thenReturn(someSettings());
        perform(get("/web/settings"))
            .andExpect(view().name("settings/settings_form"));
    }

    @Test
    void ensureSettingsSavedShowsFormIfValidationFails() throws Exception {

        doAnswer(invocation -> {
            Errors errors = invocation.getArgument(1);
            errors.rejectValue("applicationSettings", "error");
            return null;
        }).when(settingsValidator).validate(any(), any());

        perform(
            post("/web/settings")
                .param("calendarSettings.provider", "NoopCalendarSyncProvider")
                .param("calendarSettings.exchangeCalendarSettings.email", "")
                .param("calendarSettings.exchangeCalendarSettings.password", "")
                .param("calendarSettings.exchangeCalendarSettings.ewsUrl", "")
                .param("calendarSettings.exchangeCalendarSettings.calendar", "")
                .param("calendarSettings.exchangeCalendarSettings.timeZoneId", "Z")
                .param("calendarSettings.googleCalendarSettings.clientId", "")
                .param("calendarSettings.googleCalendarSettings.clientSecret", "")
                .param("calendarSettings.googleCalendarSettings.calendarId", "")
                .param("calendarSettings.googleCalendarSettings.authorizedRedirectUrl", "http://localhost:8080/web/google-api-handshake")
        )
            .andExpect(view().name("settings/settings_form"));
    }

    @Test
    void ensureSavingWorkingTimeSettings() throws Exception {

        final Settings storedSettings = someSettings();
        when(settingsService.getSettings()).thenReturn(storedSettings);

        perform(
            post("/web/settings")
                // required settings stuff for the form POST
                .param("absenceTypeSettings.items[0].id", "1000")
                .param("absenceTypeSettings.items[0].active", "true")
                .param("_absenceTypeSettings.items[0].active", "on")
                .param("_absenceTypeSettings.items[0].requiresApproval", "on")
                // actual system under test
                .param("workingTimeSettings.workingDays", "1")
                .param("_workingTimeSettings.workingDays", "on")
                .param("_workingTimeSettings.workingDays", "on")
                .param("workingTimeSettings.workingDays", "3")
                .param("_workingTimeSettings.workingDays", "on")
                .param("workingTimeSettings.workingDays", "4")
                .param("_workingTimeSettings.workingDays", "on")
                .param("workingTimeSettings.workingDays", "5")
                .param("_workingTimeSettings.workingDays", "on")
                .param("_workingTimeSettings.workingDays", "on")
                .param("_workingTimeSettings.workingDays", "on")
                .param("specialLeaveSettings.specialLeaveSettingsItems[0].id", "11")
        )
            .andExpect(redirectedUrl("/web/settings"));

        final ArgumentCaptor<Settings> settingsArgumentCaptor = ArgumentCaptor.forClass(Settings.class);

        verify(settingsService).save(settingsArgumentCaptor.capture());

        final Settings savedSettings = settingsArgumentCaptor.getValue();
        final WorkingTimeSettings savedWorkingTimeSettings = savedSettings.getWorkingTimeSettings();
        assertThat(savedWorkingTimeSettings.getMonday()).isEqualTo(DayLength.FULL);
        assertThat(savedWorkingTimeSettings.getTuesday()).isEqualTo(DayLength.ZERO);
        assertThat(savedWorkingTimeSettings.getWednesday()).isEqualTo(DayLength.FULL);
        assertThat(savedWorkingTimeSettings.getThursday()).isEqualTo(DayLength.FULL);
        assertThat(savedWorkingTimeSettings.getFriday()).isEqualTo(DayLength.FULL);
        assertThat(savedWorkingTimeSettings.getSaturday()).isEqualTo(DayLength.ZERO);
        assertThat(savedWorkingTimeSettings.getSunday()).isEqualTo(DayLength.ZERO);
    }

    @Test
    void ensureSettingsSavedSavesSettingsIfValidationSuccessfully() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettings());

        perform(
            post("/web/settings")
                .param("absenceTypeSettings.items[0].id", "10")
                .param("specialLeaveSettings.specialLeaveSettingsItems[0].id", "11")
        );

        verify(settingsService).save(any(Settings.class));
    }

    @Test
    void validateSpecialLeaves() throws Exception {

        perform(
            post("/web/settings")
                .param("calendarSettings.exchangeCalendarSettings.timeZoneId", "Z")
                .param("specialLeaveSettings.specialLeaveSettingsItems[0].days", "-1")

        )
            .andExpect(model().attributeHasFieldErrors("settings", "specialLeaveSettings.specialLeaveSettingsItems[0].days"))
            .andExpect(model().attributeHasFieldErrorCode("settings", "specialLeaveSettings.specialLeaveSettingsItems[0].days", "Min"));
    }

    @Test
    void ensureSettingsSavedAddFlashAttributeAndRedirectsToSettings() throws Exception {

        when(settingsService.getSettings()).thenReturn(someSettings());

        perform(
            post("/web/settings")
                .param("absenceTypeSettings.items[0].id", "10")
                .param("specialLeaveSettings.specialLeaveSettingsItems[0].id", "11")
        )
            .andExpect(flash().attribute("success", true));

        perform(
            post("/web/settings")
                .param("absenceTypeSettings.items[0].id", "10")
                .param("specialLeaveSettings.specialLeaveSettingsItems[0].id", "11")
        )
            .andExpect(status().isFound())
            .andExpect(redirectedUrl("/web/settings"));
    }

    private static Settings someSettings() {
        final Settings settings = new Settings();
        settings.setId(1);
        settings.setApplicationSettings(new ApplicationSettings());
        settings.setAccountSettings(new AccountSettings());
        settings.setWorkingTimeSettings(new WorkingTimeSettings());
        settings.setOvertimeSettings(new OvertimeSettings());
        settings.setTimeSettings(new TimeSettings());
        settings.setSickNoteSettings(new SickNoteSettings());
        settings.setCalendarSettings(new CalendarSettings());
        return settings;
    }

    private static Settings someSettingsWithNoExchangeTimezone() {
        return someSettings();
    }

    private static Settings someSettingsWithExchangeTimeZone(String timeZoneId) {
        final Settings settings = someSettings();
        settings.getCalendarSettings().getExchangeCalendarSettings().setTimeZoneId(timeZoneId);
        return settings;
    }

    private static Settings someSettingsWithoutGoogleCalendarRefreshToken() {
        return someSettings();
    }

    private static Settings someSettingsWithGoogleCalendarRefreshToken() {
        final Settings settings = someSettings();
        settings.getCalendarSettings().getGoogleCalendarSettings().setRefreshToken(SOME_GOOGLE_REFRESH_TOKEN);
        return settings;
    }

    private ResultActions perform(MockHttpServletRequestBuilder builder) throws Exception {
        return standaloneSetup(sut).build().perform(builder);
    }

    private static class SomeCalendarProvider implements CalendarProvider {

        @Override
        public boolean isRealProviderConfigured() {
            return true;
        }

        @Override
        public Optional<String> add(Absence absence, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void update(Absence absence, String eventId, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void delete(String eventId, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void checkCalendarSyncSettings(CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }
    }

    private static class AnotherCalendarProvider implements CalendarProvider {

        @Override
        public boolean isRealProviderConfigured() {
            return true;
        }

        @Override
        public Optional<String> add(Absence absence, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void update(Absence absence, String eventId, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void delete(String eventId, CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }

        @Override
        public void checkCalendarSyncSettings(CalendarSettings calendarSettings) {
            throw new UnsupportedOperationException("This is just a mock to have some named CalendarProvider impl.");
        }
    }
}
