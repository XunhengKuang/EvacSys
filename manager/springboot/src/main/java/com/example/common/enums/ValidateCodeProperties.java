package com.example.common.enums;

public class ValidateCodeProperties {
    private Long time=120L;
    private String type="png";
    private Integer width=130;
    private Integer height=48;
    private Integer length=4;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getWidth() {
        return width;
    }

    public void setWidth(Integer width) {
        this.width = width;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Integer getLength() {
        return length;
    }

    public void setLength(Integer length) {
        this.length = length;
    }

    public Integer getCharType() {
        return charType;
    }

    public void setCharType(Integer charType) {
        this.charType = charType;
    }

    private Integer charType=2;
    public Long getTime(){
        return time;
    }
    public void setTime(Long time){
        this.time=time;
    }
}
