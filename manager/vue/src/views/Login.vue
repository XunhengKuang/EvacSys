<template>
  <div class="container">
    <div style="width: 380px; padding: 30px; background-color: rgba(255, 255, 255, .6); border-radius: 5px;">
      <div style="text-align: center; font-size: 24px; margin-bottom: 30px; color: #333">应急疏散管理系统</div>
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input size="medium" prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input size="medium" prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
        </el-form-item>
        <el-form-item prop="role">
          <el-select size="medium" v-model="form.role" style="width: 100%">
            <el-option value="USER" label="用户"></el-option>
            <el-option value="ADMIN" label="管理员"></el-option>
            <el-option value="VOLUNTEER" label="安保"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <div style="display: flex">
            <el-input size="medium" style="flex: 1" v-model="form.code" placeholder="请输入验证码"></el-input>
            <div style="flex: 1; margin-left: 10px"><img @click="getCode()" :src="codeImg" style="width: 100%; height: 35px"/></div>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button size="medium" type="primary" style="width: 100%;" @click="login">登 录</el-button>
        </el-form-item>

        <div style="display: flex; align-items: center">
          <div style="flex: 1"></div>
          <div style="flex: 1; text-align: right">
            还没有账号？请 <a href="/register">注册</a>
          </div>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      codeImg: '',
      uuid: '',
      form: { role: 'ADMIN' },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ]
      },
    }
  },
  created() {
    this.getCode()
  },
  methods: {
    getCode() {
      this.uuid = generateUUID()
      this.codeImg = this.$baseUrl + '/validateCode?key=' + this.uuid
    },
    login() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.form.key=this.uuid
          this.$request.post('/login', this.form).then(res => {
            if (res.code === '200') {
              localStorage.setItem("xm-user", JSON.stringify(res.data))  // 存储用户数据
              this.$router.push('/')  // 跳转主页
              this.$message.success('登录成功')
            } else {
              this.getCode();
              this.$message.error(res.msg)
            }
          })
        }
      })
    }
  }
}
function generateUUID() {
  let d = new Date().getTime();
  if (window.performance && typeof window.performance.now === "function") {
    d += performance.now(); //use high-precision timer if available
  }
  let uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    let r = (d + Math.random() * 16) % 16 | 0;
    d = Math.floor(d / 16);
    return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
  });
  return uuid;
}
</script>

<style scoped>
.container {
  height: 100vh;
  overflow: hidden;
  background-image: url("@/assets/imgs/bg.jpg");
  background-size: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
}
a {
  color: #2a60c9;
}
</style>