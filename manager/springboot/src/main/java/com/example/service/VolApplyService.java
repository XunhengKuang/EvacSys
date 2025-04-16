package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.User;
import com.example.entity.VolApply;
import com.example.entity.Volunteer;
import com.example.exception.CustomException;
import com.example.mapper.UserMapper;
import com.example.mapper.VolApplyMapper;
import com.example.mapper.VolunteerMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 安保申请业务处理
 **/
@Service
public class VolApplyService {

    @Resource
    private VolApplyMapper volApplyMapper;
    @Resource
    VolunteerMapper volunteerMapper;
    @Resource
    UserService userService;

    /**
     * 新增
     */
    public void add(VolApply volApply) {
        Account currenUser= TokenUtils.getCurrentUser();
        VolApply dbVol=volApplyMapper.selectByUserId(currenUser.getId());
        if(ObjectUtil.isNotEmpty(dbVol)){
            if("通过".equals(dbVol.getStatus())||"待审核".equals(dbVol.getStatus())){
                throw new CustomException(ResultCodeEnum.VOL_APPLY_EXIST_ERROR);
            }else{
                this.deleteById(currenUser.getId());
            }
        }
        volApply.setUserId(currenUser.getId());
        volApply.setTime(DateUtil.now());
        volApply.setStatus("待审核");
        volApplyMapper.insert(volApply);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        volApplyMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            volApplyMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(VolApply volApply) {
        volApplyMapper.updateById(volApply);
    }

    /**
     * 根据ID查询
     */
    public VolApply selectById(Integer id) {
        return volApplyMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<VolApply> selectAll(VolApply volApply) {
        return volApplyMapper.selectAll(volApply);
    }

    /**
     * 分页查询
     */
    public PageInfo<VolApply> selectPage(VolApply volApply, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<VolApply> list = volApplyMapper.selectAll(volApply);
        return PageInfo.of(list);
    }

    public void audit(VolApply volApply) {
        String status=volApply.getStatus();
        if("通过".equals(status)){
            User user=userService.selectById(volApply.getUserId());
            if(ObjectUtil.isEmpty(user)){
                return;
            }
            String username=user.getUsername();
            Volunteer dbVol=volunteerMapper.selectByUsername(username);
            if(ObjectUtil.isNotEmpty(dbVol)){
                throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
            }
            Volunteer vol=new Volunteer();
            vol.setUsername(username);
            vol.setPassword(user.getPassword());
            vol.setRole(RoleEnum.VOLUNTEER.name());
            vol.setName(user.getName());
            vol.setAvatar(user.getAvatar());
            vol.setInfo(volApply.getInfo());
            vol.setBirth(volApply.getBirth());
            vol.setSex(volApply.getSex());
            vol.setCardImg(volApply.getCardImg());
            vol.setCardNo(volApply.getCardNo());
            vol.setPhone(volApply.getPhone());
            volunteerMapper.insert(vol);
        }
        this.updateById(volApply);
    }

    public VolApply selectByUserId(Integer userId) {
        return volApplyMapper.selectByUserId(userId);
    }
}