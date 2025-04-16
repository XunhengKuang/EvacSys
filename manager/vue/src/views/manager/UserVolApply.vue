<template>
  <div style="width: 50%" class="card">
    <div style="text-align: center;margin-bottom: 30px;font-size: 20px">安保申请</div>
    <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
      <el-form-item label="电话" prop="phone">
        <el-input v-model="form.phone" placeholder="电话"></el-input>
      </el-form-item>
      <el-form-item label="性别" prop="sex">
        <el-radio-group v-model="form.sex">
          <el-radio label="男"></el-radio>
          <el-radio label="女"></el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="生日" prop="birth">
        <el-date-picker format="yyyy-MM-dd" value-format="yyyy-MM-dd"
                        v-model="form.birth" style="width: 100%"></el-date-picker>
      </el-form-item>
      <el-form-item label="身份证号码" prop="cardNo">
        <el-input v-model="form.cardNo" placeholder="身份证号码"></el-input>
      </el-form-item>
      <el-form-item label="身份证照片" prop="cardImg">
        <el-upload
            :action="$baseUrl + '/files/upload'"
            :headers="{ token: user.token }"
            list-type="picture"
            :on-success="handleCardImgSuccess"
        >
          <el-button type="primary">上传身份证照片</el-button>
        </el-upload>
      </el-form-item>
      <el-form-item label="个人介绍" prop="info">
        <el-input v-model="form.info" placeholder="个人介绍" type="textarea"></el-input>
      </el-form-item>
      <el-form-item label="审核状态" prop="status" v-if="form.status">
        <strong style="color: orange" v-if="form.status==='待审核' ">待审核</strong>
        <strong style="color: #3fa50c" v-if="form.status==='通过' ">通过</strong>
        <strong style="color: red" v-if="form.status==='拒绝' ">拒绝</strong>
      </el-form-item>
      <div style="text-align: center">
        <el-button @click="submit" size="medium" type="primary">提交信息</el-button>
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: "UserVolApply",
  data(){
    return{
      user:JSON.parse(localStorage.getItem('xm-user')||'{}'),
      form: {},
      rules: {

      }
    }
  },
  created() {
    console.log(this.user)
    this.load()
  },
  methods:{
    handleCardImgSuccess(response) {
      this.form.cardImg = response.data
    },
    load(){
      this.$request.get('/volApply/selectByUserId/'+this.user.id).then(res=>{
        this.form=res.data||{}
      })
    },
    submit(){
      this.$request.post('/volApply/add',this.form).then(res=>{
        if(res.code === '200'){
          this.$message.success('提交成功')
          this.load()
        }else{
          this.$message.error(res.msg)
        }
      })
    }
  }
}
</script>

<style scoped>

</style>