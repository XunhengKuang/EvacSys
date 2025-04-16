<template>
  <div>
    <div class="card" style="padding: 15px">
      您好，{{ user?.name }}！本系统
      <el-button type="danger" size="medium" style="margin-left: 10px" @click="$router.push('/help')">疏散演习</el-button>
    </div>
    <div style="display: flex; margin: 10px 0;grid-gap: 10px">
      <div class="card" style="flex: 1">
        <div style="margin-bottom: 30px; font-size: 20px; font-weight: bold">应急科普</div>
        <div v-for="item in knowledgeList" :key="item.id" style="margin-bottom: 10px">
          <div><span style=" font-size: 18px;cursor: pointer" @click="$router.push('/knowledgeDetail?id='+item.id)">{{item.title}}</span><span style="color:#666;margin-left: 20px;font-size: 12px">{{item.date}}</span></div>
        </div>
        <div style="margin: 20px 0" v-if="total>pageSize">
          <el-pagination
              @current-change="handleCurrentChange"
              :current-page="pageNum"
              :page-sizes="[5, 10, 20]"
              :page-size="pageSize"
              layout="prev, pager, next"
              :total="total">
          </el-pagination>
        </div>
      </div>
      <div style="width: 50%;flex: 1" class="card">
        <div style="margin-bottom: 30px; font-size: 20px; font-weight: bold">公告列表</div>
        <div >
          <el-timeline  reverse slot="reference">
            <el-timeline-item v-for="item in notices" :key="item.id" :timestamp="item.time">
              <el-popover
                  placement="right"
                  width="200"
                  trigger="hover"
                  :content="item.content">
                <span slot="reference">{{ item.title }}</span>
              </el-popover>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import knowledge from "@/views/manager/Knowledge.vue";

export default {
  name: 'Home',
  computed: {
    knowledge() {
      return knowledge
    }
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      notices: [],
      knowledgeList:[],
      pageNum:1,
      pageSize:5,
      total:0
    }
  },
  created() {
    this.$request.get('/notice/selectAll').then(res => {
      this.notices = res.data || []
    })
    this.load(1)
  },
  methods:{
    load(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/knowledge/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
        }
      }).then(res => {
        if (res.code === '200') {
          this.knowledgeList = res.data?.list
          this.total = res.data?.total
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  }
}
</script>
