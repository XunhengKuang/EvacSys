package com.example.entity;

import java.io.Serializable;

/**
 * 出警信息
 */
public class Records implements Serializable {
    private static final long serialVersionUID = 1L;

    /** ID */
    private Integer id;
    /** 安保ID */
    private Integer volId;
    /** 状态 */
    private String status;
    /** 疏散时间 */
    private String time;
    /** 事件ID */
    private Integer helpId;
    /** 备注 */
    private String comment;
    private String volName;
    private String volPhone;

    public String getVolPhone() {
        return volPhone;
    }

    public void setVolPhone(String volPhone) {
        this.volPhone = volPhone;
    }

    public String getVolName() {
        return volName;
    }

    public void setVolName(String volName) {
        this.volName = volName;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getVolId() {
        return volId;
    }

    public void setVolId(Integer volId) {
        this.volId = volId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public Integer getHelpId() {
        return helpId;
    }

    public void setHelpId(Integer helpId) {
        this.helpId = helpId;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}