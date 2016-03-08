### fir login & fir me

`fir login` 命令用于使用 API token 登录 fir.im, 并使用发布应用等相关命令.

`fir me` 命令用于查看当前登录用户信息.

用户的 API token 可在 **[这里](http://fir.im/apps/apitoken)** 查看, 当使用 fir login 登录了之后, 后续命令都不需要加上 `-T` 参数, 会默认使用 **当前用户的 token** 进行相关操作.

```sh
$ fir login XXX_YOUR_API_TOKEN_XXX
I, [2016-03-08T12:48:56.499435 #13043]  INFO -- : Login succeed, previous user's email: xxx@fir.im
I, [2016-03-08T12:48:56.507044 #13043]  INFO -- : Login succeed, current  user's email: xxx@fir.im
I, [2016-03-08T12:48:56.507147 #13043]  INFO -- :

$ fir me
I, [2016-03-08T12:48:14.175488 #12986]  INFO -- : Login succeed, current user's email: xxx@fir.im
I, [2016-03-08T12:48:14.175687 #12986]  INFO -- : Login succeed, current user's name:  xxx
I, [2016-03-08T12:48:14.175765 #12986]  INFO -- :
```
