<template>
  <div>
    <div style="margin-bottom: 20px; font-size: 22px; font-weight: bold">留言 {{ commentCount }}</div>
    <div style="margin-bottom: 20px">
      <el-input type="textarea" placeholder="请输入留言" v-model="content"></el-input>
      <div style="text-align: right; margin-top: 5px"><el-button type="primary" @click="addComment(null)">留言</el-button></div>
    </div>

    <div>
      <div v-for="item in commentList" :key="item.id" style="margin-bottom: 20px">
        <!-- 一级留言-->
        <div style="display: flex; margin-bottom: 20px">
          <img :src="item.avatar" alt="" style="width: 50px; height: 50px; border-radius: 50%">
          <div style="padding-left: 15px; flex: 1">
            <div style="margin-bottom: 10px; color: #666">{{ item.userName }}</div>
            <div style="margin-bottom: 5px">{{ item.content }}</div>
            <div style="color: #666; font-size: 13px; margin-bottom: 5px">
              <span>{{ item.time }}</span>
              <span @click="handleShowReply(item)" style="margin: 0 20px; cursor: pointer"
                    :class="{'comment-active' : item.showReply}"><i class="el-icon-s-comment"></i>回复</span>
              <span @click="delComment(item.id)" v-if="item.userId === user.id" style="cursor: pointer"><i class="el-icon-delete"></i>删除</span>
            </div>
            <div v-if="item.showReply">
              <el-input type="textarea" placeholder="请输入回复" v-model="item.replyContent"></el-input>
              <div style="text-align: right; margin-top: 5px"><el-button type="primary" @click="addComment(item)">回复</el-button></div>
            </div>
          </div>
        </div>
        <!-- 二级留言-->
        <div v-if="item.children" style="padding-left: 65px">
          <div v-for="sub in item.children" style="display: flex; margin-bottom: 20px">
            <img :src="sub.avatar" alt="" style="width: 50px; height: 50px; border-radius: 50%">
            <div style="padding-left: 15px; flex: 1">
              <div style="margin-bottom: 10px; color: #666">{{ sub.userName }} <span v-if="sub.parentUserName !== item.userName">回复：{{ sub.parentUserName }}</span></div>
              <div style="margin-bottom: 5px">{{ sub.content }}</div>
              <div style="color: #666; font-size: 13px; margin-bottom: 5px">
                <span>{{ sub.time }}</span>
                <span @click="handleShowReply(sub)" style="margin: 0 20px; cursor: pointer"
                      :class="{'comment-active' : sub.showReply}"><i class="el-icon-s-comment"></i>回复</span>
                <span @click="delComment(sub.id)" v-if="sub.userId === user.id" style="cursor: pointer"><i class="el-icon-delete"></i>删除</span>
              </div>
              <div v-if="sub.showReply">
                <el-input type="textarea" placeholder="请输入回复" v-model="sub.replyContent"></el-input>
                <div style="text-align: right; margin-top: 5px"><el-button type="primary" @click="addComment(sub)">回复</el-button></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div style="margin-top: 10px" v-if="total > pageSize">
        <el-pagination
            small
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
  </div>
</template>

<script>
export default {
  name: "CommentComponent",
  props: {
    fid: null,
    module: null
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      commentCount: 0,
      content: '',
      commentList: [],
      pageNum: 1,
      pageSize: 5,
      total: 0
    }
  },
  created() {
    this.loadComment()
  },
  methods: {
    handleShowReply(comment) {
      this.$set(comment, 'showReply', !comment.showReply)
    },
    delComment(commentId) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/comment/delete/' + commentId).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.loadComment()
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    loadComment() {
      this.$request.get('/comment/selectTree/' + this.fid + '/' + this.module, {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
        }
      }).then(res => {
        this.commentList = res.data?.list || []
        this.total = res.data?.total || 0
      })

      this.$request.get('/comment/selectCount/' + this.fid + '/' + this.module).then(res => {
        this.commentCount = res.data || 0
      })
    },
    addComment(comment) {  //  comment 有值表示这是回复
      let data = { fid: this.fid, userId: this.user.id, module: this.module, content: this.content }
      if (comment) {
        data.content = comment.replyContent
        data.pid = comment.id
      }
      if (!data.content) {
        this.$message.warning('请输入内容!')
        return
      }
      this.$request.post('/comment/add', data).then(res => {
        if (res.code === '200') {
          this.$message.success('操作成功')
          this.content = ''
          this.loadComment()
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.loadComment()
    },
  }
}
</script>

<style scoped>

</style>