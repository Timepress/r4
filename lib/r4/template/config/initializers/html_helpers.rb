module ApplicationHelper

  def t_header name
    header = t("activerecord.attributes.#{name}")
    header[0] = header[0].upcase
    header
  end

  # make long text short with '...'
  def shorten text, length=20
    return '' unless text.present?
    res = text.scan /^(.{1,#{length}})(.*)/
    "#{res[0][0]}#{res[0][1].present? ? '...' : ''}"
  end

  def num_warn condition
    "num #{'warn' if condition}"
  end

  def records_filter
  concat t('records') + ': ' +
    select_tag('filter[per_page]', options_for_select(%w[30 50 100],
         filter.params[:per_page]) ) + "\n"
  end

  def menu_item name, url, test
    %Q{<li#{' class=active' if params[:controller]+params[:action]=~test }><a href="#{url}">#{ name }</a></li>}.html_safe
  end

  # same as I18n.l() but ignores nil
  def lf date, options={}
    l(date, options) if date
  end

  # selecting - yes, no, nil
  def yes_no_select
    [nil, [t('yes'), 'yes'], [t('no'), 'no'] ]
  end

  def session_debug
    "#{session['debug_params']}<br />#{link_to_function 'debug', "$('#debug_div').toggle()",
        class: 'btn thin'}<hr class='separation'/><div class='box white spaced' id='debug_div'
        style='display:none'>params:#{params.inspect}<br /><br />session#{session.inspect
        }<br /><br />referrer:#{request.referrer}".html_safe if DEVEL && session['debug_params']
    session['debug_params']=''
  end
end
