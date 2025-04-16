package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.common.Constants;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Admin;
import com.example.entity.User;
import com.example.exception.CustomException;
import com.example.mapper.UserMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 用户业务处理
 **/
@Service
public class UserService {

    @Resource
    private UserMapper userMapper;

    /**
     * 新增
     */
    public void add(User user) {
        User dbUser=userMapper.selectByUsername(user.getUsername());
        if(ObjectUtil.isNotEmpty(dbUser)){
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        if(ObjectUtil.isEmpty(user.getName())){
            user.setName(user.getUsername());
        }
        user.setRole(RoleEnum.USER.name());
        userMapper.insert(user);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        userMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            userMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(User user) {
        userMapper.updateById(user);
    }

    /**
     * 根据ID查询
     */
    public User selectById(Integer id) {
        return userMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<User> selectAll(User user) {
        return userMapper.selectAll(user);
    }

    /**
     * 分页查询
     */
    public PageInfo<User> selectPage(User user, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> list = userMapper.selectAll(user);
        return PageInfo.of(list);
    }


    public Account login(Account account) {
        Account dbaccount=userMapper.selectByUsername(account.getUsername());
        if(ObjectUtil.isNull(dbaccount)){
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if(!account.getPassword().equals(dbaccount.getPassword())){
            throw new CustomException(ResultCodeEnum.USER_ACCOUNT_ERROR);
        }
        String tokenData=dbaccount.getId()+"-"+RoleEnum.USER.name();
        String token=TokenUtils.createToken(tokenData,dbaccount.getPassword());
        dbaccount.setToken(token);
        return dbaccount;
    }

    public void register(Account account) {
        User user=new User();
        user.setUsername(account.getUsername());
        user.setPassword(account.getPassword());
        this.add(user);
    }

    public void updatePassword(Account account) {
        User dbuser=userMapper.selectByUsername(account.getUsername());
        if(ObjectUtil.isNull(dbuser)){
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if(!account.getPassword().equals(dbuser.getPassword())){
            throw new CustomException(ResultCodeEnum.PARAM_PASSWORD_ERROR);
        }
        dbuser.setPassword(account.getNewPassword());
        userMapper.updateById(dbuser);
    }
}