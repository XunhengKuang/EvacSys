package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Donate;
import com.example.mapper.DonateMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 安全隐患业务处理
 **/
@Service
public class DonateService {

    @Resource
    private DonateMapper donateMapper;

    /**
     * 新增
     */
    public void add(Donate donate) {
        Account account= TokenUtils.getCurrentUser();
        donate.setUserId(account.getId());
        donate.setStatus("待审核");
        donate.setTime(DateUtil.now());
        donateMapper.insert(donate);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        donateMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            donateMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Donate donate) {
        Account account=TokenUtils.getCurrentUser();
        if(RoleEnum.USER.name().equals(account.getRole())){
            donate.setStatus("待审核");
        }
        donateMapper.updateById(donate);
    }

    /**
     * 根据ID查询
     */
    public Donate selectById(Integer id) {
        return donateMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Donate> selectAll(Donate donate) {
        return donateMapper.selectAll(donate);
    }

    /**
     * 分页查询
     */
    public PageInfo<Donate> selectPage(Donate donate, Integer pageNum, Integer pageSize) {
        Account account=TokenUtils.getCurrentUser();
        if(RoleEnum.USER.name().equals(account.getRole())){
            donate.setUserId(account.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Donate> list = donateMapper.selectAll(donate);
        return PageInfo.of(list);
    }

}