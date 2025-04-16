<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入关键字查询" style="width: 200px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="primary" plain @click="handleAdd" v-if="user.role==='USER'">发起捐赠</el-button>
      <el-button type="danger" plain @click="delBatch" v-if="user.role==='ADMIN'">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" strip @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="user.role==='ADMIN'"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable v-if="user.role==='ADMIN'"></el-table-column>
        <el-table-column prop="name" label="隐患名称"></el-table-column>
        <el-table-column prop="descr" label="隐患描述"></el-table-column>
        <el-table-column prop="type" label="类型"></el-table-column>
        <el-table-column prop="img" label="隐患图片">
          <template v-slot="scope">
            <el-image v-if="scope.row.img" style="width: 50px" :src="scope.row.img" :preview-src-list="[scope.row.img]"></el-image>
          </template>
        </el-table-column>
        <el-table-column prop="userId" label="用户ID"></el-table-column>
        <el-table-column prop="userName" label="用户名称"></el-table-column>
        <el-table-column prop="time" label="提交时间"></el-table-column>
        <el-table-column prop="status" label="状态">
          <template v-slot="scope">
            <el-tag type="info" v-if="scope.row.status === '待审核'">待审核</el-tag>
            <el-tag type="success" v-if="scope.row.status === '通过'">通过</el-tag>
            <el-tag type="danger" v-if="scope.row.status === '拒绝'">拒绝</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="审核理由"></el-table-column>
        <el-table-column label="操作" align="center" width="180">
          <template v-slot="scope">
            <el-button size="mini" type="primary" plain @click="handleAudit(scope.row)" v-if="user.role==='ADMIN'">审核</el-button>
            <el-button size="mini" type="primary" plain @click="handleEdit(scope.row)" v-if="user.role==='USER'&&scope.row.status!=='通过'">编辑</el-button>
            <el-button size="mini" type="danger" plain @click="del(scope.row.id)" v-if="user.role==='USER'&&scope.row.status!=='通过'">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
            background
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[5, 10, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total">
        </el-pagination>
      </div>
    </div>

    <el-dialog title="安全隐患审核" :visible.sync="fromVisible1" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="审核状态" prop="status">
          <el-select v-model="form.status" style="width: 100%">
            <el-option :value="item" v-for="item in ['待审核','通过','拒绝']" :key="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审核理由" prop="name">
          <el-input v-model="form.reason" type="textarea"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible1 = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="安全隐患" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="隐患名称" prop="name">
          <el-input v-model="form.name" placeholder="隐患名称"></el-input>
        </el-form-item>
        <el-form-item label="隐患描述" prop="descr">
          <el-input v-model="form.descr" placeholder="隐患描述" type="textarea"></el-input>
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="form.type" style="width: 100%">
            <el-option :value="item" v-for="item in ['逃生通道占用', '饮用水', '被子', '旧衣服']" :key="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="隐患图片" prop="img">
          <el-upload
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              list-type="picture"
              :on-success="handleImgSuccess"
          >
            <el-button type="primary">上传</el-button>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>


  </div>
</template>
<script>
export default {
  name: "Donate",
  data() {
    return {
      tableData: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 10,  // 每页显示的个数
      total: 0,
      name: null,
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
      },
      ids: [],
      fromVisible1:false
    }
  },
  created() {
    this.load(1)
  },
  methods: {
    handleAudit(row){
      this.fromVisible1=true
      this.form = JSON.parse(JSON.stringify(row))
    },
    handleAdd() {   // 新增数据
      this.form = {}  // 新增数据的时候清空数据
      this.fromVisible = true   // 打开弹窗
    },
    handleEdit(row) {   // 编辑数据
      this.form = JSON.parse(JSON.stringify(row))  // 给form对象赋值  注意要深拷贝数据
      this.fromVisible = true   // 打开弹窗
    },
    save() {   // 保存按钮触发的逻辑  它会触发新增或者更新
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request({
            url: this.form.id ? '/donate/update' : '/donate/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {  // 表示成功保存
              this.$message.success('操作成功')
              this.load(1)
              this.fromVisible = false
              this.fromVisible1=false
            } else {
              this.$message.error(res.msg)  // 弹出错误的信息
            }
          })
        }
      })
    },
    del(id) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/donate/delete/' + id).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {   // 当前选中的所有的行数据
      this.ids = rows.map(v => v.id)
    },
    delBatch() {   // 批量删除
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/donate/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/donate/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list
          this.total = res.data?.total
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    reset() {
      this.name = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
    handleImgSuccess(response, file, fileList) {
      this.form.img = response.data
    },
  }
}
</script>

<style scoped>

</style>