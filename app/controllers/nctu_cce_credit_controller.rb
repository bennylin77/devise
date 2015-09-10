class NctuCceCreditController < ApplicationController
  before_filter :authenticate_user!   
  before_action only: [:export, :editPeriod, :updatePeriod, :askFeedback, :sendMessage, :indexManagement, :destroy, :editCourses, :updateCourses, :vacc_export, :attendancePrint, :editCollaborators, :addCollaborator, :destroyCollaborator] { |c| c.PeriodCheckUser(params[:id])}  
  before_action only: [:cancel, :feedback] { |c| c.ProgressCheckUser(params[:id])}   
  before_action only: [:editGroup, :updateGroup] { |c| c.GroupCheckUser(params[:id])}  
  before_action only: [:destroyProgress, :verified, :updateVAccount, :add_course] { |c| c.ProgressCheckPeriodUser(params[:id])}    
  before_action only: [:updateScore] {|c| c.RegisteredCourseCheckPeriodUser(params[:id])} 
  before_action only: [:first, :second, :third, :forth, :fifth] {|c| c.checkStage(params[:id])}
  before_action :set_period, only: [:indexManagement, :export, :editPeriod, :updatePeriod, :editScore, :editVAccount, :editFeedback, :askFeedback, :sendMessage, :destroy, :editCourses, :updateCourses, :first, :second, :third, :forth, :fifth, 
                                    :attendancePrint, :exportAttendance, :exportAttendanceForTeacher, :editCollaborators, :addCollaborator, :destroyCollaborator]  
  before_action :set_group, only: [:editGroup, :updateGroup]  
  before_action :set_progress, only: [:showProgress, :verified, :cancel, :destroyProgress, :feedback, :user_print, :updateVAccount] 
      
  def new
    @group = Group.new()
    @group.periods.build()    
    @step = 2    
  end
  def exportScoreList
		@course=Course.find(params[:id])
		respond_to do |format|
			format.xls{
				response.headers['Content-Type'] = 'application/vnd.ms-excel; charset="utf-8" '
				response.headers['Content-Disposition'] = " attachment; filename=\"成績列表.xls\" "	
			}
		end
	end
	
  def newCourses
    @group = Group.new(group_params)      
    @step = 2     
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.periods.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.periods.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.periods.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.periods.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.periods.first.start_at, second: @group.periods.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.periods.first.payment_start_at, second: @group.periods.first.payment_end_at }}                                    
                                    ])                                  
    checkValidations(validations: validations_result, render: 'new' ) 
    @step = 3      
  end
  
  def create
    @group = Group.new(group_params)      
    @title = params[:title]
    @price = params[:price]
    @no_of_users = params[:no_of_users]    
    @start_at = params[:start_at]   
    @end_at = params[:end_at]     
    @location = params[:location]   
    @note = params[:note]                
    @step = 3    
    validations_result=validations([{type: 'presence', title: '班級名稱', data: @group.title},
                                    {type: 'presence', title: '班級簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.periods.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.periods.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.periods.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.periods.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.periods.first.start_at, second: @group.periods.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.periods.first.payment_start_at, second: @group.periods.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )       
    params[:title].each_with_index do |t, i|
      validations_result=validations([{type: 'presence', title: '課程名稱', data: t},     
                                      {type: 'presence', title: '學費', data: params[:price][i]},   
                                      {type: 'presence', title: '招生人數', data: params[:no_of_users][i]}                                                                                   
                                      ])        
      checkValidations(validations: validations_result, render: 'newCourses' )                                           
    end
    @group.periods.first.user = current_user 
    @group.system_module = SystemModule.where(serial_code: GLOBAL_VAR['NCTU_CCE_credit']).first    
    @group.save      
    params[:title].each_with_index do |t, i|
      @group.periods.first.courses.create(title: t, price: params[:price][i], no_of_users: params[:no_of_users][i], start_at: params[:start_at][i], end_at: params[:end_at][i], location: params[:location][i], note: params[:note][i] )    
    end   
    redirect_to controller: :periods, action: :createCompletion, id: @group.periods.first.id  
  end  

  def destroy
    @period.group.destroy    
    flash[:success]="成功刪除學分班"    
    redirect_to controller: 'periods', action: 'indexManagement'  
  end

  def indexManagement
    @progresses = @period.progresses.order('stage desc').paginate(page: params[:page], per_page: 30)
  end  

  def editPeriod  
  end 
  
  def updatePeriod
    @period.assign_attributes(period_params)
    validations_result=validations([{type: 'presence', title: '報名開放時間', data: @period.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @period.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @period.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @period.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @period.start_at, second: @period.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @period.payment_start_at, second: @period.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'editPeriod' )   
    @period.save  
    flash[:success]="成功更新班級資料"
    redirect_to controller: :nctu_cce_credit, action: :editPeriod, id: @period.id     
  end  
  
  def editGroup  
  end 
  
  def updateGroup
    @group.assign_attributes(group_params)
    validations_result=validations([{type: 'presence', title: '名稱', data: @group.title},
                                    {type: 'presence', title: '簡介', data: @group.description}])                                   
    checkValidations(validations: validations_result, render: 'editGroup' )   
    @group.save  
    flash[:success]="成功更新名稱簡介"
    redirect_to controller: :nctu_cce_credit, action: :editGroup, id: @group.id     
  end    
  
  def editCourses     
  end
  
  def updateCourses 
    @title = params[:title]
    @price = params[:price]
    @no_of_users = params[:no_of_users]    
    @start_at = params[:start_at]   
    @end_at = params[:end_at]     
    @location = params[:location]   
    @note = params[:note] 
    unless params[:title].blank?    
      params[:title].each_with_index do |t, i|
        validations_result=validations([{type: 'presence', title: '課程名稱', data: t},     
                                        {type: 'presence', title: '學費', data: params[:price][i]},   
                                        {type: 'presence', title: '招生人數', data: params[:no_of_users][i]}                                                                                   
                                        ])        
        checkValidations(validations: validations_result, render: 'editCourses' )                                           
      end
      params[:title].each_with_index do |t, i|
        @period.courses.create(title: t, price: params[:price][i], no_of_users: params[:no_of_users][i], start_at: params[:start_at][i], end_at: params[:end_at][i], location: params[:location][i], note: params[:note][i] )    
      end       
    end
     
    @period.assign_attributes(period_params)        
    @period.courses.each do |ii|
      validations_result=validations([{type: 'presence', title: '課程名稱', data: ii.title},     
                                      {type: 'presence', title: '學費', data: ii.price},   
                                      {type: 'presence', title: '招生人數', data: ii.no_of_users}                                                                                   
                                      ])        
      checkValidations(validations: validations_result, render: 'editCourses' )                                           
    end    
    @period.save  
    flash[:success]="成功更新課程"
    redirect_to controller: :nctu_cce_credit, action: :editCourses, id: @period.id        
  end

  def editCollaborators
  end

  def addCollaborator
    unless User.where(email: params[:email]).first.blank?  
      if User.where(email: params[:email]).first.collaborators.where(period: @period).count == 0 and User.where(email: params[:email]).first != current_user
        col = Collaborator.new     
        col.user = User.where(email: params[:email]).first           
        col.period = @period
        col.save!
        flash[:success]="成功新增共同管理者"              
      else
        flash[:error] = '此會員已是管理者'            
      end    
    else
      flash[:error] = '無此會員信箱'  
    end    
    redirect_to controller: :nctu_cce_credit, action: :editCollaborators, id: @period.id            
  end

  def destroyCollaborator
    col = Collaborator.find(params[:collaborator_id])
    col.destroy!    
    flash[:success] = '成功刪除共同管理者'
    redirect_to controller: :nctu_cce_credit, action: :editCollaborators, id: @period.id            
  end  

  def editScore
  end
    
  def updateScore
    r_c = RegisteredCourse.find(params[:id])
    case params[:type]
    when 'score'
      r_c.score = params[:val]
      r_c.save!
      render json: {success: true, message: '成功更改分數'}                 
    when 'attendance'  
      r_c.attendance = params[:val]
      r_c.save!
      render json: {success: true, message: '成功更改出席率'}   
    when 'certificate'  
      r_c.certificate = params[:val]
      r_c.save!  
      render json: {success: true, message: '成功更改資格'}    
    when 'certificate_no'  
      r_c.certificate_no = params[:val]
      r_c.save!  
      render json: {success: true, message: '成功更改證書字號'}                                                                          
    end    
  end

  def editFeedback
  end
  
  def askFeedback
    @period.progresses.gte(stage: 4).each do |p|    
      p.stage = 5
      p.save!
      System.sendFeedbackAsking(user: p.user, progress: p).deliver      
    end
    
    flash[:success]="成功寄送教學反映問卷邀請"
    redirect_to controller: :nctu_cce_credit, action: :editFeedback, id: @period.id       
  end  
   
  def editVAccount
    #ado 這裡幫我連出納機器檢查 @period 裡的每一個vaccount 是不是銷帳了並且更新收據號碼-----start
		@period.progresses.each do |progress|
			va=progress.try(:vaccount).try(:updateIsclosedAndReceiveNo)
			
			#va.updateIsclosedAndReceiveNo
		end
    #ado 這裡幫我連出納機器檢查 @period 裡的每一個vaccount 是不是銷帳了並且更新收據號碼-----end    
  end 

  def updateVAccount
    vaccount = @progress.vaccount
    case params[:type]
    when 'purpose'
      if !vaccount.is_closed
        vaccount.purpose = params[:val]
				vaccount.save!
        #ado 這裡幫我連出納機器改事由-----start
        vaccount.syncMssqlPurpose
        #ado 這裡幫我連出納機器改事由-----end        
        
        render json: {success: true, message: '成功更改收據事由'}   
      else
        render json: {success: false, message: '已銷帳無法更改收據事由'}           
      end                  
    when 'ack'  
      if !vaccount.is_closed
        vaccount.purpose = params[:purpose_val]
        vaccount.paid_by = @progress.user.name
        vaccount.ack_status = true
        vaccount.save!
				#ado 這裡幫我連出納機器 改認領狀況 繳款人-----start
				vaccount.syncMssqlPaidByAndAck
				#ado 這裡幫我連出納機器 改認領狀況 繳款人-----end     
        render json: {success: true, message: '成功認領'}   
      else
        render json: {success: false, message: '無法再認領'}           
      end                                                                
    end     
  end
    
  def sendMessage 
    if request.post?       
      params[:recipients].each do |r|
        progress = @period.progresses.where(user_id: r).first        
        params[:content] = params[:content].gsub(/\{name\}/, User.find(r).name)  
        unless progress.vaccount.blank?
          params[:content] = params[:content].gsub(/\{vaccount\}/, progress.vaccount.vacc.to_s)  
        end
        params[:content] = params[:content].gsub(/\{payment\}/, progress.payment.to_s)  
        System.sendMessage(user: User.find(r), subject: params[:subject], content: params[:content], attachment: params[:attachment], sender: current_user, progress: progress).deliver
      end 
      flash[:success]="成功寄出信件"                
      redirect_to controller: :nctu_cce_credit, action: :sendMessage, id: @period.id     
    end
  end  
  
  def verified
    if params[:verify] == 'false'
      @progress.verified = false
      @progress.stage = 1
      @progress.reason = params[:reason]
      @progress.payment = 0
      @progress.registered_courses.destroy_all
      if @progress.vaccount
        @progress.vaccount.active = false 
        @progress.vaccount.save!
      end
      @progress.save!
      flash[:error]="審核不通過/取消資格 "+@progress.user.name+" 的報名"
      System.sendUnverified(user: @progress.user, progress: @progress).deliver         
    else
      @progress.verified = true 
      @progress.payment = params[:registered_course_payments].map(&:to_i).reduce(0, :+) + params[:default_payment].to_i
      params[:registered_course_ids].each_with_index do |id, idx|
      	registered_course = @progress.registered_courses.find(id)
      	registered_course.payment = params[:registered_course_payments][idx].to_f
      	registered_course.save!
      end
      if @progress.vaccount #可能之前被退回時就創過
      	@progress.vaccount.active = true
      	@progress.vaccount.save!
      elsif @progress.payment > 0 #若免錢就不給帳號
      	@progress.create_vaccount
      end	 
      @progress.stage= (@progress.payment > 0) ? 3 : 4 #免錢直接過 stage==4  
      @progress.save!    
      flash[:success]="已審核通過 "+@progress.user.name+" 的報名"
      System.sendVerified(user: @progress.user, progress: @progress).deliver         
    end
    redirect_to controller: 'nctu_cce_credit', action: 'showProgress', id: @progress.id
  end

  def destroyProgress
    period = @progress.period
    @progress.destroy    
    flash[:success]="成功刪除報名"    
    redirect_to controller: 'nctu_cce_credit', action: 'indexManagement', id: period.id       
  end
  
  def showProgress
  	@progress = Progress.find(params[:id])
  end
	
	def export	  
	end
	
	def edit_fee
		@progress = Progress.find(params[:id])
		old_payment = @progress.payment
		@progress.payment = params[:default_payment].to_i
		if params[:registered_course_payments].present?
			@progress.payment += params[:registered_course_payments].map(&:to_i).reduce(0, :+)
		end
		params[:registered_course_ids].each_with_index do |id, idx|
			registered_course = @progress.registered_courses.find(id)
			registered_course.payment = params[:registered_course_payments][idx].to_f
			registered_course.save!
		end
    if old_payment != @progress.payment
			@progress.stage=3
		end
		if @progress.payment==0
			@progress.stage=4
		end
		@progress.save!    
		flash[:success]="已成功更改金額!"
    #System.sendVerified(user: @progress.user, progress: @progress).deliver         
    redirect_to controller: 'nctu_cce_credit', action: 'showProgress', id: @progress.id
  end
	
	def add_course
		@progress = Progress.find(params[:id])
		#@progress.registered_courses=[]
		#@progress.period.courses.where(id: params[:c_id]).first.registered_courses = []
		#@progress.period.save
		action=params[:type]
		if params[:c_id].blank? 
			flash[:error]="未輸入course id"
		else
			case action
				when "add"
					if !@progress.registered_courses.where(course_id:params[:c_id]).empty? #can't add course which is already in registered_courses
						flash[:error]="已加選此課程!"
					else			
						registered_course = RegisteredCourse.new  
						@progress.registered_courses << registered_course
						@progress.period.courses.where(id: params[:c_id]).first.registered_courses << registered_course 
						registered_course.save 
						@progress.period.save
						flash[:success]="加選課程 #{registered_course.course.title} 成功!"
					end
				when "delete"
					if @progress.registered_courses.where(course_id:params[:c_id]).empty? #can't delete course which isn't in registered_courses yet
						flash[:error]="尚未選擇此課程!"
					else			
						@progress.registered_courses.where(course_id: params[:c_id]).destroy_all
						@progress.period.courses.where(id: params[:c_id]).first.registered_courses.where(course_id: params[:c_id]).destroy_all
						flash[:success]="退選課程 #{Course.find(params[:c_id]).title} 成功!"
						if @progress.registered_courses.empty?
							@progress.update(:stage=>1)
						end
					end
					
				else
					flash[:error]="動作錯誤!"
			end
		end
		redirect_to "/nctu_cce_credit/showProgress?id=#{params[:id]}"
	end
	
  def exportAttendance
		
    respond_to do |format|
			 format.xls{
			 	response.headers['Content-Type'] = 'application/vnd.ms-excel; charset="utf-8" '
			 	response.headers['Content-Disposition'] = " attachment; filename=\"#{Time.now.strftime("%Y-%m-%d")}簽到表.xls\" "	
			 }
		end	 
  end  
	
	def exportAttendanceForTeacher
		
    respond_to do |format|
			 format.xls{
			 	response.headers['Content-Type'] = 'application/vnd.ms-excel; charset="utf-8" '
			 	response.headers['Content-Disposition'] = " attachment; filename=\"#{Time.now.strftime("%Y-%m-%d")}點名單.xls\" "	
			 }
			 format.html{}
		end	 
  end  
	
  def attendancePrint
   render layout: false
  end  
 

# ------------ booking --------------#
  def cancel
    if @progress.stage > 2 
      flash[:alert]="您已通過審核, 無法退出報名"    
      redirect_to controller: 'periods', action: 'progress'              
    else  
      @progress.destroy    
      flash[:success]="成功退出報名"    
      redirect_to controller: 'periods', action: 'progress'       
    end  
  end

  def first
    @user=current_user 
    progress = @period.progresses.where(user_id: current_user.id).first
    if progress.blank?
      @progress=Progress.new
      @progress.stage=1
      @progress.user = current_user           
      @progress.period = @period                  
      @progress.save           
    else
      @progress = progress        
    end    
    @step = 1      
  end  

  def second
    @progress = @period.progresses.where(user_id: current_user.id).first               
    if @progress.stage == 1
      user = current_user  
      user.assign_attributes(user_params) 
      @step = 1      
      validations_result=validations([{type: 'presence', title: '姓名', data: user_params[:name]}, 
                                      {type: 'presence', title: '英文姓名', data: user_params[:name_en]},      
                                      {type: 'presence', title: '出生年月日', data: user_params[:birthday]},
                                      {type: 'presence', title: '性別', data: user_params[:gender]},
                                      {type: 'presence', title: '國籍', data: user_params[:nationality]},
                                      {type: 'presence', title: '聯絡電話(行動)',data: user_params[:mobile_phone_no]},
                                      {type: 'presence', title: '郵遞區號', data: user_params[:postal]},
                                      {type: 'presence', title: '聯絡地址-縣市', data: user_params[:county]},                                      
                                      {type: 'presence', title: '聯絡地址-鄉鎮市區', data: user_params[:district]},        
                                      {type: 'presence', title: '聯絡地址-詳細', data: user_params[:address]},
                                      {type: 'presence', title: '最高(畢/肄/就讀)學校', data: user_params[:hightest_education_school]},
                                      {type: 'presence', title: '最高(科/系/所)', data: user_params[:hightest_education_department]},                                                               
                                      {type: 'nationality', title: { first: '身分證字號', second: '居留證號碼' }, data: { first: user_params[:nationality], second: user_params[:id_no_TW], third: user_params[:ARC_no_TW] }}
                                      ]) 
      checkValidations(validations: validations_result, render: 'first' )               
      user.save    
      validations_result=validations([{type: 'presence', title: '選擇課程', data: params[:courses]}])      
      checkValidations(validations: validations_result, render: 'first' )      
      @progress.stage=2
      @progress.reason = ''        
      @progress.save   
      params[:courses].each do |c|
        registered_course = RegisteredCourse.new  
        @progress.registered_courses << registered_course
        @period.courses.where(id: c).first.registered_courses << registered_course 
        registered_course.save 
      end
      @period.save                  
      System.sendVerifyNotification(user: @progress.period.user, progress: @progress).deliver                                           
    end 
    @step = 2         
  end
  
  def third
    @step = 3     
    @progress = @period.progresses.where(user_id: current_user.id).first  
  end
  
  def forth
    @step = 4       
    @progress = @period.progresses.where(user_id: current_user.id).first    
  end

  def fifth
    @step = 5       
    @progress = @period.progresses.where(user_id: current_user.id).first         
  end 
  
  def feedback
    @step = 5    
    @progress.assign_attributes(progress_params)   
    params[:progress][:registered_courses_attributes].each do |key, r|     
      validations_result=validations([{type: 'presence', title: '我對教師的教學態度', data: r[:nctu_cce_feedback_1_1]}, {type: 'presence', title: '我對教師的授課方法', data: r[:nctu_cce_feedback_1_2]}, {type: 'presence', title: '我對本課程的內容與結構', data: r[:nctu_cce_feedback_1_3]}, {type: 'presence', title: '我對本課程的作業、報告、考試與評分方式', data: r[:nctu_cce_feedback_1_4]},
                                      {type: 'presence', title: '我對本課程的整體印象', data: r[:nctu_cce_feedback_1_5]}, 
                                      {type: 'presence', title: '我覺得教師課前準備得很充足', data: r[:nctu_cce_feedback_2_1]}, {type: 'presence', title: '教師上課熱忱、認真、負責', data: r[:nctu_cce_feedback_2_2]}, {type: 'presence', title: '教師的教學方法適切', data: r[:nctu_cce_feedback_2_3]}, {type: 'presence', title: '教師授課的表達與說明清楚', data: r[:nctu_cce_feedback_2_4]},
                                      {type: 'presence', title: '教師的課堂時間分配恰當', data: r[:nctu_cce_feedback_2_5]}, {type: 'presence', title: '本課程所教內容前後有組織、有條理', data: r[:nctu_cce_feedback_2_6]}, {type: 'presence', title: '使用之教科書、教材或講義對學習很有幫助', data: r[:nctu_cce_feedback_2_7]}, {type: 'presence', title: '教師教授的教材內容充實豐富', data: r[:nctu_cce_feedback_2_8]},
                                      {type: 'presence', title: '考試、作業的內容對學習很有幫助', data: r[:nctu_cce_feedback_2_9]}, {type: 'presence', title: '考核與評分的方式公平合理', data: r[:nctu_cce_feedback_2_10]}, {type: 'presence', title: '我可以很容易在教師的office hours或是利用其他方式與教師聯絡', data: r[:nctu_cce_feedback_2_11]},  
                                     ])
      checkValidations(validations: validations_result, render: 'fifth' )      
    end  
    @progress.feedback_done = true    
    @progress.save!
    flash.now[:success] = '成功完成評價'
    render 'fifth' 
  end  
 
  def export_users
    period = Period.find(params[:id])
    @progresses = period.progresses.gte(:stage=>4)
    time_str = Time.now.strftime("%Y%m%d%H%M")
    respond_to do |format|
			 format.xls{
			 	response.headers['Content-Type'] = 'application/vnd.ms-excel; charset="utf-8" '
			 	response.headers['Content-Disposition'] = " attachment; filename=\"#{time_str}學員資料.xls\" "	
			 }
		end	 
  end
  
  def user_print
	 render :layout=> false
  end
  
  private

  def set_period
    @period = Period.find(params[:id])
  end 
  
  def set_group
    @group = Group.find(params[:id])
  end   
  
  def set_progress
    @progress = Progress.find(params[:id])     
  end
  
  def period_params
    params.require(:period).permit( :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :default_payment, courses_attributes: [:title, :no_of_users, :price, :id, :start_at, :end_at, :location, :note])      
  end

  def user_params
    params.require(:user).permit(:name, :birthday, :gender, :id_no_TW, :ARC_no_TW, :mobile_phone_no, :phone_no, :address, 
                                 :postal, :county, :district, :name_en, :hightest_education_school, :hightest_education_department,
                                 :work_name, :work_title, :work_phone_no, :work_fax_no, :work_county, :work_district, :work_postal, :work_address,
                                 :work_contact_name, :work_contact_phone_no, :work_contact_email, :head_pic, :qualification_proof, :nationality)      
  end
  
  def group_params
    params.require(:group).permit(:title, :description, periods_attributes: [:start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :default_payment])
  end     
  
  def progress_params
    params.require(:progress).permit( registered_courses_attributes: [:id,
          :nctu_cce_feedback_1_1, :nctu_cce_feedback_1_2, :nctu_cce_feedback_1_3, :nctu_cce_feedback_1_4, :nctu_cce_feedback_1_5, 
          :nctu_cce_feedback_2_1, :nctu_cce_feedback_2_2, :nctu_cce_feedback_2_3,  :nctu_cce_feedback_2_4, :nctu_cce_feedback_2_5,  
          :nctu_cce_feedback_2_6,  :nctu_cce_feedback_2_7,  :nctu_cce_feedback_2_8, :nctu_cce_feedback_2_9,   :nctu_cce_feedback_2_10,  :nctu_cce_feedback_2_11,    
          :nctu_cce_feedback_3_1,  :nctu_cce_feedback_4_1,  :nctu_cce_feedback_4_2, :nctu_cce_feedback_4_3, :nctu_cce_feedback_4_4, :nctu_cce_feedback_4_5      
    ]) 
  end
  
end