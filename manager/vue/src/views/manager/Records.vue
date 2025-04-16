<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入关键字查询" style="width: 200px" v-model="volName"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation" v-if="user.role==='ADMIN'">
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" strip @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="user.role==='ADMIN'"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="volName" label="安保名称"></el-table-column>
        <el-table-column prop="status" label="状态">
          <template v-slot="scope">
            <el-tag type="warn" v-if="scope.row.status === '待疏散'">待疏散</el-tag>
            <el-tag type="info" v-if="scope.row.status === '疏散中'">疏散中</el-tag>
            <el-tag type="success" v-if="scope.row.status === '已疏散'">已疏散</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="time" label="疏散时间"></el-table-column>
        <el-table-column prop="helpId" label="事件详情">
          <template v-slot="scope">
            <el-button @click="view(scope.row.helpId)">查看详情</el-button>
          </template>
        </el-table-column>
        <el-table-column prop="comment" label="备注"></el-table-column>
        <el-table-column label="操作" align="center" width="220">
          <template v-slot="scope">
            <el-button size="mini" type="primary" plain @click="changeStatus(scope.row,'疏散中')" v-if="scope.row.status==='待疏散'&&user.role==='VOLUNTEER'">应答</el-button>
            <el-button size="mini" type="success" plain @click="changeStatus(scope.row,'已疏散')" v-if="scope.row.status==='疏散中'&&user.role==='VOLUNTEER'">完成疏散</el-button>
            <el-button size="mini" type="danger" plain @click="del(scope.row.id)" v-if="user.role==='ADMIN'">删除</el-button>
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
    <el-dialog title="疏散场所信息" :visible.sync="fromVisible1" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form label-width="120px">
        <el-form-item label="事故名称">
          <div>
            {{help.name}}
          </div>
        </el-form-item>
        <el-form-item label="事故内容">
          <div>
            {{help.content}}
          </div>
        </el-form-item>
        <el-form-item label="现场照片">
          <div>
            <img :src="help.img" style="width: 200px">
          </div>
        </el-form-item>
        <el-form-item label="事故地点">
          <div>
            {{help.location}}
          </div>
        </el-form-item>

        <el-form-item label="求救人名称">
          <div>
            {{help.userName}}
          </div>
        </el-form-item>
        <el-form-item label="求救电话">
          <div>
            {{help.phone}}
          </div>
        </el-form-item>
        <el-form-item label="事故时间">
          <div>
            {{help.time}}
          </div>
        </el-form-item>
      </el-form>
    </el-dialog>
    <el-dialog title="出警信息" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="安保ID" prop="volId">
          <el-input v-model="form.volId" placeholder="安保ID"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-input v-model="form.status" placeholder="状态"></el-input>
        </el-form-item>
        <el-form-item label="疏散时间" prop="time">
          <el-input v-model="form.time" placeholder="疏散时间"></el-input>
        </el-form-item>
        <el-form-item label="事件ID" prop="helpId">
          <el-input v-model="form.helpId" placeholder="事件ID"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="comment">
          <el-input v-model="form.comment" placeholder="备注"></el-input>
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
  volName: "Records",
  data() {
    return {
      tableData: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 10,  // 每页显示的个数
      total: 0,
      volName: null,
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
      },
      ids: [],
      help:{},
      fromVisible1:false,
    }
  },
  created() {
    this.load(1)
  },
  methods: {
    view(helpId){
      this.$request.get('/help/selectById/'+helpId).then(res=>{
        this.help=res.data||{}
      })
      this.fromVisible1=true
    },
    changeStatus(row,status){
      this.$confirm("您确认吗？","确认操作",{type:"info"}).then(res=>{
        row.status=status
        this.$request.put('records/update',row).then(res=>{
          if (res.code === '200') {  // 表示成功保存
            this.$message.success('出警成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(()=>{})

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
            url: this.form.id ? '/records/update' : '/records/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {  // 表示成功保存
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)  // 弹出错误的信息
            }
          })
        }
      })
    },
    del(id) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/records/delete/' + id).then(res => {
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
        this.$request.delete('/records/delete/batch', {data: this.ids}).then(res => {
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
      this.$request.get('/records/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          volName: this.volName,
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
      this.volName = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  }
}
</script>

<style scoped>
/deep/.el-form-item__label{
  font-weight: bold;
}
</style>