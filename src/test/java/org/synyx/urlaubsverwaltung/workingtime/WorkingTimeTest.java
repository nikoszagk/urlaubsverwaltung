package org.synyx.urlaubsverwaltung.workingtime;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.synyx.urlaubsverwaltung.period.DayLength;
import org.synyx.urlaubsverwaltung.period.WeekDay;

import java.time.DayOfWeek;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static java.time.DayOfWeek.FRIDAY;
import static java.time.DayOfWeek.MONDAY;
import static java.time.DayOfWeek.SATURDAY;
import static java.time.DayOfWeek.SUNDAY;
import static java.time.DayOfWeek.THURSDAY;
import static java.time.DayOfWeek.TUESDAY;
import static java.time.DayOfWeek.WEDNESDAY;
import static java.util.stream.Collectors.toList;
import static org.assertj.core.api.Assertions.assertThat;
import static org.synyx.urlaubsverwaltung.period.DayLength.FULL;
import static org.synyx.urlaubsverwaltung.period.DayLength.ZERO;


/**
 * Unit test for {@link WorkingTime}.
 */
class WorkingTimeTest {

    @Test
    void testDefaultValues() {

        final WorkingTime workingTime = new WorkingTime();
        assertThat(workingTime.getMonday()).isEqualTo(ZERO);
        assertThat(workingTime.getTuesday()).isEqualTo(ZERO);
        assertThat(workingTime.getWednesday()).isEqualTo(ZERO);
        assertThat(workingTime.getThursday()).isEqualTo(ZERO);
        assertThat(workingTime.getFriday()).isEqualTo(ZERO);
        assertThat(workingTime.getSaturday()).isEqualTo(ZERO);
        assertThat(workingTime.getSunday()).isEqualTo(ZERO);
        assertThat(workingTime.getFederalStateOverride()).isEmpty();
    }

    @Test
    void testHasWorkingDaysIdentical() {

        final  List<Integer> workingDays = Arrays.asList(MONDAY.getValue(), TUESDAY.getValue(),
            WEDNESDAY.getValue(), THURSDAY.getValue(), FRIDAY.getValue());

        final  List<Integer> workingDaysToCompare = Arrays.asList(FRIDAY.getValue(), TUESDAY.getValue(),
            WEDNESDAY.getValue(), MONDAY.getValue(), THURSDAY.getValue());

        final WorkingTime workingTime = new WorkingTime();
        workingTime.setWorkingDays(workingDays, FULL);

        final boolean returnValue = workingTime.hasWorkingDays(workingDaysToCompare);
        assertThat(returnValue).isTrue();
    }

    @Test
    void testHasWorkingDaysDifferent() {

        final List<Integer> workingDays = Arrays.asList(MONDAY.getValue(), TUESDAY.getValue(),
            WEDNESDAY.getValue(), THURSDAY.getValue(), FRIDAY.getValue());

        final List<Integer> workingDaysToCompare = Arrays.asList(MONDAY.getValue(), TUESDAY.getValue(),
            WEDNESDAY.getValue(), THURSDAY.getValue(), SUNDAY.getValue());

        final WorkingTime workingTime = new WorkingTime();
        workingTime.setWorkingDays(workingDays, FULL);

        final boolean returnValue = workingTime.hasWorkingDays(workingDaysToCompare);
        assertThat(returnValue).isFalse();
    }

    @Test
    void ensureWorkingDaysInWorkingTimeList() {

        final List<Integer> workingDays = Stream.of(MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY)
            .map(DayOfWeek::getValue)
            .collect(toList());

        final WorkingTime workingEveryDay = new WorkingTime();
        workingEveryDay.setWorkingDays(workingDays, FULL);

        assertThat(workingEveryDay.getWorkingDays())
            .containsExactly(WeekDay.MONDAY, WeekDay.TUESDAY, WeekDay.WEDNESDAY, WeekDay.THURSDAY, WeekDay.FRIDAY, WeekDay.SATURDAY, WeekDay.SUNDAY);

        final WorkingTime workingNoDay = new WorkingTime();
        workingNoDay.setWorkingDays(workingDays, ZERO);

        assertThat(workingNoDay.getWorkingDays()).isEmpty();
    }

    @ParameterizedTest
    @CsvSource({
        "1,FULL", "1,MORNING", "1,NOON",
        "2,FULL", "2,MORNING", "2,NOON",
        "3,FULL", "3,MORNING", "3,NOON",
        "4,FULL", "4,MORNING", "4,NOON",
        "5,FULL", "5,MORNING", "5,NOON",
        "6,FULL", "6,MORNING", "6,NOON",
        "7,FULL", "7,MORNING", "7,NOON"
    })
    void ensureIsWorkingDayIsTrue(int dayOfWeek, DayLength dayLength) {
        final WorkingTime workingTime = new WorkingTime();
        workingTime.setDayLengthForWeekDay(dayOfWeek, dayLength);
        assertThat(workingTime.isWorkingDay(DayOfWeek.of(dayOfWeek))).isTrue();
    }

    @ParameterizedTest
    @CsvSource({"1", "2", "3", "4", "5", "6", "7"})
    void ensureIsWorkingDayIsFalseForDayLengthZero(int dayOfWeek) {
        final WorkingTime workingTime = new WorkingTime();
        workingTime.setDayLengthForWeekDay(dayOfWeek, ZERO);
        assertThat(workingTime.isWorkingDay(DayOfWeek.of(dayOfWeek))).isFalse();
    }

    @Test
    void equals() {
        final WorkingTime WorkingTimeOne = new WorkingTime();
        WorkingTimeOne.setId(1);

        final WorkingTime WorkingTimeOneOne = new WorkingTime();
        WorkingTimeOneOne.setId(1);

        final WorkingTime WorkingTimeTwo = new WorkingTime();
        WorkingTimeTwo.setId(2);

        assertThat(WorkingTimeOne)
            .isEqualTo(WorkingTimeOne)
            .isEqualTo(WorkingTimeOneOne)
            .isNotEqualTo(WorkingTimeTwo)
            .isNotEqualTo(new Object())
            .isNotEqualTo(null);
    }

    @Test
    void hashCodeTest() {
        final WorkingTime WorkingTimeOne = new WorkingTime();
        WorkingTimeOne.setId(1);

        assertThat(WorkingTimeOne.hashCode()).isEqualTo(32);
    }
}
