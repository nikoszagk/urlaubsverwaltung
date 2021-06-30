package org.synyx.urlaubsverwaltung.overtime;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class OvertimeSettings {

    /**
     * Activates or deactivates overtime settings.
     *
     * @since 2.15.0
     */
    @Column(name = "overtime_active")
    private boolean overtimeActive = false;

    @Column(name = "overtime_reduction_without_application_active")
    private boolean overtimeReductionWithoutApplicationActive = true;

    /**
     * Defines the maximum number of overtime a person can have.
     *
     * @since 2.13.0
     */
    @Column(name = "overtime_maximum")
    private Integer maximumOvertime = 100;

    /**
     * Defines the minimum number of overtime a person can have. Minimum overtime means missing hours (equates to
     * negative)
     *
     * @since 2.15.0
     */
    @Column(name = "overtime_minimum")
    private Integer minimumOvertime = 5;


    public boolean isOvertimeActive() {
        return overtimeActive;
    }

    public void setOvertimeActive(boolean overtimeActive) {
        this.overtimeActive = overtimeActive;
    }

    public boolean isOvertimeReductionWithoutApplicationActive() {
        return overtimeReductionWithoutApplicationActive;
    }

    public void setOvertimeReductionWithoutApplicationActive(boolean overtimeReductionWithoutApplicationActive) {
        this.overtimeReductionWithoutApplicationActive = overtimeReductionWithoutApplicationActive;
    }

    public Integer getMaximumOvertime() {
        return maximumOvertime;
    }

    public void setMaximumOvertime(Integer maximumOvertime) {
        this.maximumOvertime = maximumOvertime;
    }

    public Integer getMinimumOvertime() {
        return minimumOvertime;
    }

    public void setMinimumOvertime(Integer minimumOvertime) {
        this.minimumOvertime = minimumOvertime;
    }
}
