commit="post"

run:
	hugo server --theme=zzo --buildDrafts -w

build:
	@echo "开始编译"
	hugo --theme=zzo --baseUrl="https://week8.fun/"
	@echo "编译完成"
	@echo "正在推送文章"
	git add .
	git commit -m '${commit}'
	git push
	cd public/;git add .;git commit -m '${commit}';git push
	@echo "推送完成"


