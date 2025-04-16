package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.User;
import com.example.entity.Volunteer;
import com.example.exception.CustomException;
import com.example.mapper.VolunteerMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 安保人员信息业务处理
 **/
@Service
public class VolunteerService {

    @Resource
    private VolunteerMapper volunteerMapper;

    /**
     * 新增
     */
    public void add(Volunteer volunteer) {
        Volunteer dbVol=volunteerMapper.selectByUsername(volunteer.getUsername());
        if(ObjectUtil.isNotEmpty(dbVol)){
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        if(ObjectUtil.isEmpty(volunteer.getName())){
           volunteer.setName(volunteer.getUsername());
        }
        volunteer.setRole(RoleEnum.VOLUNTEER.name());
        volunteerMapper.insert(volunteer);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        volunteerMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            volunteerMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Volunteer volunteer) {
        volunteerMapper.updateById(volunteer);
    }

    /**
     * 根据ID查询
     */
    public Volunteer selectById(Integer id) {
        return volunteerMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Volunteer> selectAll(Volunteer volunteer) {
        return volunteerMapper.selectAll(volunteer);
    }

    /**
     * 分页查询
     */
    public PageInfo<Volunteer> selectPage(Volunteer volunteer, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Volunteer> list = volunteerMapper.selectAll(volunteer);
        return PageInfo.of(list);
    }

    public Account login(Account account) {
        Account dbVol=volunteerMapper.selectByUsername(account.getUsername());
        if(ObjectUtil.isNull(dbVol)){
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if(!account.getPassword().equals(dbVol.getPassword())){
            throw new CustomException(ResultCodeEnum.USER_ACCOUNT_ERROR);
        }
        String tokenData=dbVol.getId()+"-"+RoleEnum.VOLUNTEER.name();
        String token= TokenUtils.createToken(tokenData,dbVol.getPassword());
        dbVol.setToken(token);
        return dbVol;
    }

    public void updatePassword(Account account) {
        Volunteer dbVol=volunteerMapper.selectByUsername(account.getUsername());
        if(ObjectUtil.isNull(dbVol)){
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if(!account.getPassword().equals(dbVol.getPassword())){
            throw new CustomException(ResultCodeEnum.PARAM_PASSWORD_ERROR);
        }
        dbVol.setPassword(account.getNewPassword());
        volunteerMapper.updateById(dbVol);
    }
}