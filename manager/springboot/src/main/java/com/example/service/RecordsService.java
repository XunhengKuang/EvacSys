package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Help;
import com.example.entity.Records;
import com.example.entity.Volunteer;
import com.example.mapper.RecordsMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 出警信息业务处理
 **/
@Service
public class RecordsService {

    @Resource
    private RecordsMapper recordsMapper;
    @Resource
    private VolunteerService volunteerService;
    @Resource
    private HelpService helpService;
    /**
     * 新增
     */
    @Transactional
    public void add(Records records) {
        records.setStatus("待疏散");
        recordsMapper.insert(records);
//        //更新安保
        Volunteer volunteer=volunteerService.selectById(records.getVolId());
        volunteer.setFree("否");
        volunteerService.updateById(volunteer);
        //更新救助信息
        Help help=helpService.selectById(records.getHelpId());
        help.setRecordId(records.getId());
        help.setStatus("进行中");
        helpService.updateById(help);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        recordsMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            recordsMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Records records) {
        if("疏散中".equals(records.getStatus())){
            records.setTime(DateUtil.now());
        }else if("已疏散".equals(records.getStatus())){
            Integer volId=records.getVolId();
            Volunteer vol=volunteerService.selectById(volId);
            vol.setFree("是");
            volunteerService.updateById(vol);
            helpService.updateStatus("已解决",records.getHelpId());
        }
        recordsMapper.updateById(records);
    }

    /**
     * 根据ID查询
     */
    public Records selectById(Integer id) {
        return recordsMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Records> selectAll(Records records) {
        return recordsMapper.selectAll(records);
    }

    /**
     * 分页查询
     */
    public PageInfo<Records> selectPage(Records records, Integer pageNum, Integer pageSize) {
        Account account= TokenUtils.getCurrentUser();
        if(RoleEnum.VOLUNTEER.name().equals(account.getRole())){
            records.setVolId(account.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Records> list = recordsMapper.selectAll(records);
        return PageInfo.of(list);
    }

}