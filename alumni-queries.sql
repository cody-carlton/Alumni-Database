select * from events order by event_id;

select * from blogs order by blog_details;

select * from blog_entries;

select * from blog_entries where author_first_name = 'Kyle';

select blog_details, Alumni_Home_Page_netword_id from blogs b
left join blog_entries be
on b.blog_id = be.blog_id;
