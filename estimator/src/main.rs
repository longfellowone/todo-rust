// https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html
// https://github.com/jaheba/stuff/blob/master/communicating_intent.md
// https://ferrisellis.com/content/rust-implementing-units-for-types/
// http://xion.io/post/code/rust-iter-patterns.html
// http://xion.io/post/code/rust-string-args.html
// https://www.reddit.com/r/rust/comments/hzx1ak/beginners_critiques_of_rust/fzm45ms?utm_source=share&utm_medium=web2x
use actix_web::{web, App, HttpResponse, HttpServer};
use anyhow::Result;
use async_graphql::http::{playground_source, GraphQLPlaygroundConfig};
use async_graphql::{Context, EmptyMutation, EmptySubscription, FieldResult, Schema};
use async_graphql::{Object, SimpleObject};
use async_graphql_actix_web::{GQLRequest, GQLResponse};
use sqlx::PgPool;

struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn assemblies(&self, ctx: &Context<'_>) -> FieldResult<Vec<Assembly>> {
        let db_pool = ctx.data::<PgPool>()?;

        let assemblies: Vec<Assembly> = sqlx::query_as!(
            Assembly,
            r#"
                SELECT id, name
                FROM assemblies
            "#,
        )
        .fetch_all(db_pool)
        .await
        .unwrap();

        Ok(assemblies)
    }
}

#[SimpleObject]
#[derive(Debug)]
struct Assembly {
    id: i32,
    name: String,
}

type TodoSchema = Schema<QueryRoot, EmptyMutation, EmptySubscription>;

async fn index(schema: web::Data<TodoSchema>, req: GQLRequest) -> GQLResponse {
    req.into_inner().execute(&schema).await.into()
}

async fn index_playground() -> actix_web::Result<HttpResponse> {
    Ok(HttpResponse::Ok()
        .content_type("text/html; charset=utf-8")
        .body(playground_source(
            GraphQLPlaygroundConfig::new("/").subscription_endpoint("/"),
        )))
}

#[actix_rt::main]
async fn main() -> Result<()> {
    let db_pool = PgPool::new("postgres://postgres:postgres@localhost/rust").await?;

    let schema = Schema::build(QueryRoot, EmptyMutation, EmptySubscription)
        .data(db_pool)
        .finish();

    HttpServer::new(move || {
        App::new()
            .data(schema.clone())
            .route("/", web::post().to(index))
            .route("/", web::get().to(index_playground))
    })
    .bind("127.0.0.1:8000")?
    .run()
    .await?;

    println!("Server started");

    Ok(())
}
